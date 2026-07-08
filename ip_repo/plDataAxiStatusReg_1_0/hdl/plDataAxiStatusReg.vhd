library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity plDataAxiStatusReg is
generic(
    nRegs     : integer;
    addrWidth : integer;
    dataWidth : integer
);
port(
    aclk     : in  std_logic;
    aresetn  : in  std_logic;
    -- Address read channel
    araddr   : in  std_logic_vector(addrWidth-1 downto 0);
    arvalid  : in  std_logic;
    arready  : out std_logic;
    -- Data read channel
    rdata    : out std_logic_vector(dataWidth-1 downto 0);
    rresp    : out std_logic_vector(1 downto 0);
    rvalid   : out std_logic;
    rready   : in  std_logic;
    -- PL regs in
    plRegsIn : in  std_logic_vector(nRegs*dataWidth-1 downto 0)
);
end plDataAxiStatusReg;

architecture behav of plDataAxiStatusReg is

constant addrLSB : integer := addrWidth/8;

type regs_t is array(integer range <>) of std_logic_vector(dataWidth-1 downto 0);

signal regs       : regs_t(nRegs-1 downto 0);

signal arreadySig,
       rvalidSig  : std_logic;

begin

assert addrWidth > 0
    report   "generic addrWidth must be > 0"
    severity failure;

assert dataWidth > 0
    report   "generic dataWidth must be > 0"
    severity failure;

assert addrWidth/8 >= 1
    report   "generic addrWidth must be multiple of 8"
    severity failure;

readProc: process(aclk)
    variable idx : integer;
begin
    if aresetn = '0' then
        arreadySig <= '0';
        rvalidSig  <= '0';
        rdata      <= (others => '0');
        rresp      <= "00";
        regs       <= (others => (others => '0'));
    else
        arreadySig <= '0';

        if arvalid = '1' and arreadySig = '0' then
            idx := to_integer(unsigned(araddr(addrWidth-1 downto addrLSB)));

            arreadySig <= '1';
            rvalidSig  <= '1';

            if idx > 0 and idx < nRegs then
                rdata  <= regs(idx);
                rresp  <= "00";
            else
                rdata  <= (others => '0');
                rresp  <= "10";
            end if;
        else
            regsPLLoop: for n in 0 to nRegs-1 loop
                regs(n) <= plRegsIn((n+1)*dataWidth-1 downto n*dataWidth);
            end loop;
        end if;

        if rready = '1' and rvalidSig = '1' then
            rvalidSig <= '0';
        end if;
    end if;
end process;

end behav;