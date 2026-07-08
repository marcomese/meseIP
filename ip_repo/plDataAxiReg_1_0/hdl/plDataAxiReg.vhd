library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity plDataAxiReg is
generic(
    nRegs     : integer;
    addrWidth : integer := 32;
    dataWidth : integer := 32
);
port(
    aclk      : in  std_logic;
    aresetn   : in  std_logic;
    -- Read address channel
    araddr    : in  std_logic_vector(addrWidth-1 downto 0);
    arvalid   : in  std_logic;
    arready   : out std_logic;
    -- Read data channel
    rdata     : out std_logic_vector(dataWidth-1 downto 0);
    rvalid    : out std_logic;
    rready    : in  std_logic;
    rresp     : out std_logic_vector(1 downto 0);
    -- Write address channel
    awaddr    : in  std_logic_vector(addrWidth-1 downto 0);
    awvalid   : in  std_logic;
    awready   : out std_logic;
    -- Write data channel
    wdata     : in  std_logic_vector(dataWidth-1 downto 0);
    wvalid    : in  std_logic;
    wready    : out std_logic;
    -- Write response channel
    bvalid    : out std_logic;
    bresp     : out std_logic_vector(1 downto 0);
    bready    : in  std_logic;
    -- PL regs channel
    plWrite   : in  std_logic;
    plRAddrIn : in  std_logic_vector(addrWidth-1 downto 0);
    plRegsIn  : in  std_logic_vector(dataWidth-1 downto 0);
    plValid   : out std_logic;
    plRegsOut : out std_logic_vector(nRegs*dataWidth-1 downto 0)
);
end plDataAxiReg;

architecture behav of plDataAxiReg is

constant addrLSB : integer := integer(ceil(log2(real(dataWidth)/8.0)));

type regs_t is array(integer range <>) of std_logic_vector(datawidth-1 downto 0);

signal arreadySig,
       rValidSig,
       awReadySig,
       wReadySig,
       bValidSig,
       plWriteSig,
       plWriteAck : std_logic;

signal plRegsInQ  : std_logic_vector(dataWidth-1 downto 0);

signal regIdx,
       plAddr     : integer;

signal regs       : regs_t(nRegs-1 downto 0);

begin

arready <= arreadySig;

rvalid  <= rValidSig;

awready <= awReadySig;

wready  <= wReadySig;

plAddr  <= to_integer(unsigned(plRAddrIn));

plRegsOutGen: for n in 0 to nRegs-1 generate
    plRegsOut((n+1)*dataWidth-1 downto n*dataWidth) <= regs(n);
end generate;

plRegsInProc: process(aclk)
begin
    if rising_edge(aclk) then
        if aresetn = '0' then
            plRegsInQ  <= (others => '0');
            plWriteSig <= '0';
        elsif plWriteAck = '1' then
            plWriteSig <= '0';
        end if;

        if plWrite = '1' then
            plRegsInQ  <= plRegsIn;
            plWriteSig <= '1';
        end if;
    end if;
end process;

readProc: process(aclk)
    variable idx : integer;
begin
    if rising_edge(aclk) then
        if aresetn = '0' then
            arreadySig <= '0';
            rValidSig  <= '0';
            rdata      <= (others => '0');
            rresp      <= (others => '0');
        else
            arreadySig <= '0';

            if arvalid = '1' and rvalidSig = '0' then
                idx := to_integer(unsigned(araddr(addrWidth-1 downto addrLSB)));

                arreadySig <= '1';
                rvalidSig  <= '1';

                if idx >= 0 and idx < nRegs then
                    rdata <= regs(idx);
                    rresp <= "00";
                else
                    rdata <= (others => '0');
                    rresp <= "10";
                end if;


            end if;

            if rvalidSig = '1' and rready = '1' then
                rValidSig  <= '0';
            end if;
        end if;
    end if;
end process;

writeProc: process(aclk)
begin
    if rising_edge(aclk) then
        if aresetn = '0' then
            regs       <= (others => (others => '0'));
            regIdx     <= 0;
            awReadySig <= '0';
            wReadySig  <= '0';
            bresp      <= "00";
            bValidSig  <= '0';
            plWriteAck <= '0';
            plValid    <= '0';
        else
            awReadySig <= '0';
            plWriteAck <= '0';
            plValid    <= '0';

            if awvalid = '1' and wReadySig = '0' and bValidSig = '0' then
                regIdx     <= to_integer(unsigned(awaddr(addrWidth-1 downto addrLSB)));
                awReadySig <= '1';
                wReadySig  <= '1';
            end if;

            if wvalid = '1' and wReadySig = '1' then
                wReadySig <= '0';
                bValidSig <= '1';

                if regIdx >= 0 and regIdx < nRegs then
                    regs(regIdx) <= wdata;
                    bresp        <= "00";
                    plValid      <= '1';
                else
                    bresp     <= "10";
                end if;
            elsif plWriteSig = '1' then
                plWriteAck <= '1';

                if plAddr >= 0 and plAddr < nRegs then
                    regs(plAddr) <= plRegsInQ;
                    plValid      <= '1';
                end if;
            end if;

            if bValidSig = '1' and bready = '1' then
                bValidSig <= '0';
            end if;
        end if;
    end if;
end process;

end behav;