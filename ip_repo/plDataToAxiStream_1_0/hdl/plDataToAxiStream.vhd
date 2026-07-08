library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library xpm;
use xpm.vcomponents.all;

entity plDataToAxiStream is
generic(
    fifoDepth   : integer := 4096;
    dataInWidth : integer := 1024;
    tDataWidth  : integer := 32
);
port(
    aclk    : in  std_logic;
    aresetn : in  std_logic;
    dataIn  : in  std_logic_vector(dataInWidth-1 downto 0);
    write   : in  std_logic;
    busy    : out std_logic;
    tready  : in  std_logic;
    tvalid  : out std_logic;
    tdata   : out std_logic_vector(tDataWidth-1 downto 0);
    tlast   : out std_logic
);
end plDataToAxiStream;

architecture arch_imp of plDataToAxiStream is

constant nWords       : integer := integer(dataInWidth/tDataWidth);

constant wordCntWidth : integer := integer(ceil(log2(real(nWords))));

signal rst,
       fifoRdEn,
       fifoEmpty,
       fifoFull,
       wrRstBusy,
       rdRstBusy : std_logic;

signal dataInInv : std_logic_vector(dataInWidth-1 downto 0);

signal wordCnt   : unsigned(wordCntWidth-1 downto 0);

begin

assert nWords > 0
    report   "generic nWord must be > 0"
    severity failure;
assert fifoDepth > 15
    report   "generic fifoDepth must be > 15"
    severity failure;
assert dataInWidth > 0
    report   "generic dataInWidth must be > 0"
    severity failure;
assert tDataWidth > 0
    report   "generic tDataWidth must be > 0"
    severity failure;
assert (dataInWidth mod tDataWidth) = 0
    report   "generic dataInWidth must be a multiple of tDataWidth"
    severity failure;

rst      <= not aresetn;

tvalid   <= not fifoEmpty;

tlast    <= '1' when wordCnt = 0 else '0';

fifoRdEn <= (not fifoEmpty) and tready;

busy     <= fifoFull or rdRstBusy or wrRstBusy;

dataInInvGen: for n in 0 to nWords-1 generate
begin
    dataInInv(dataInInv'left-n*tDataWidth downto dataInInv'left-(n+1)*tDataWidth+1) <= dataIn((n+1)*tDataWidth-1 downto n*tDataWidth);
end generate;

wordCounter: process(aclk)
begin
    if rising_edge(aclk) then
        if aresetn = '0' then
            wordCnt <= to_unsigned(nWords-1, wordCnt'length);
        elsif fifoRdEn = '1' then
            if wordCnt = 0 then
                wordCnt <= to_unsigned(nWords-1, wordCnt'length);
            else
                wordCnt <= wordCnt - 1;
            end if;
        end if;
    end if;
end process;

dataFifo: xpm_fifo_sync
generic map(
    FIFO_WRITE_DEPTH    => fifoDepth,
    WRITE_DATA_WIDTH    => dataInWidth,
    READ_DATA_WIDTH     => tDataWidth,
    FIFO_READ_LATENCY   => 0, 
    READ_MODE           => "fwft",
    USE_ADV_FEATURES    => "0000",
    SIM_ASSERT_CHK      => 1,
    FIFO_MEMORY_TYPE    => "block"
)
port map(
    wr_clk        => aclk,
    rst           => rst,
    din           => dataInInv,
    wr_en         => write,
    dout          => tdata,
    rd_en         => fifoRdEn,
    empty         => fifoEmpty,
    full          => fifoFull,
    wr_rst_busy   => wrRstBusy,
    rd_rst_busy   => rdRstBusy,
    sleep         => '0',
    injectdbiterr => '0',
    injectsbiterr => '0'
);

end arch_imp;
