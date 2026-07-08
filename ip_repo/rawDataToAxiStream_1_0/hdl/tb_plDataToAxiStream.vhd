library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_plDataToAxiStream is
end tb_plDataToAxiStream;

architecture Behavioral of tb_plDataToAxiStream is

component plDataToAxiStream is
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
end component;

constant clkPeriod   : time    := 10 ns;
constant fifoDepth   : integer := 4096;
constant dataInWidth : integer := 128;
constant tDataWidth  : integer := 32;

signal aclk    : std_logic := '1';
signal aresetn : std_logic := '0';
signal dataIn  : std_logic_vector(dataInWidth-1 downto 0) := (others => '0');
signal write   : std_logic := '0';
signal busy    : std_logic := '0';
signal tready  : std_logic := '0';
signal tvalid  : std_logic := '0';
signal tdata   : std_logic_vector(tDataWidth-1 downto 0) := (others => '0');
signal tlast   : std_logic := '0';

begin

stimProc: process
begin
    wait until aresetn = '1';

    wait until busy = '0';

    wait for clkPeriod;

    dataIn <= x"1ABC_DEF0_1234_5678_FEDC_BA12_9876_CECE";
    write  <= '1', '0' after clkPeriod*2;

    wait until tvalid = '1';
    tready <= '1';

    wait;
end process;

aresetn <= '1' after clkPeriod*5;

aclk    <= not aclk after clkPeriod/2;

plDataToAxiStreamInst: plDataToAxiStream
generic map(
    fifoDepth   => fifoDepth,
    dataInWidth => dataInWidth,
    tDataWidth  => tDataWidth
)
port map(
    aclk    => aclk,
    aresetn => aresetn,
    dataIn  => dataIn,
    write   => write,
    busy    => busy,
    tready  => tready,
    tvalid  => tvalid,
    tdata   => tdata,
    tlast   => tlast
);

end Behavioral;