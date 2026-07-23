library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rawDataToAxiStream is
	generic (
		-- Users to add parameters here
        rawDataSize : integer := 1024;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M00_AXIS_START_COUNT	: integer	:= 32
	);
	port (
		-- Users to add ports here
        dataIn    : in std_logic_vector(rawDataSize-1 downto 0);
        write     : in std_logic;
		busy      : out std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic
	);
end rawDataToAxiStream;

architecture arch_imp of rawDataToAxiStream is

	-- component declaration
	component rawDataToAxiStream_master_stream_v1_0_M00_AXIS is
		generic (
		rawDataSize : integer := 1024;
		C_M_AXIS_TDATA_WIDTH	: integer	:= 32;
		C_M_START_COUNT	: integer	:= 32
		);
		port (
        dataIn    : in  std_logic_vector(rawDataSize-1 downto 0);
        write     : in  std_logic;
        busy      : out std_logic;
		M_AXIS_ACLK	: in std_logic;
		M_AXIS_ARESETN	: in std_logic;
		M_AXIS_TVALID	: out std_logic;
		M_AXIS_TDATA	: out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
		M_AXIS_TSTRB	: out std_logic_vector((C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
		M_AXIS_TLAST	: out std_logic;
		M_AXIS_TREADY	: in std_logic
		);
	end component rawDataToAxiStream_master_stream_v1_0_M00_AXIS;

    signal dataRegister : std_logic_vector(rawDataSize-1 downto 0);

begin

-- Instantiation of Axi Bus Interface M00_AXIS
rawDataToAxiSteam_master_stream_v1_0_M00_AXIS_inst : rawDataToAxiStream_master_stream_v1_0_M00_AXIS
	generic map (
	    rawDataSize => rawDataSize,
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
	    dataIn => dataRegister,
	    write  => write,
	    busy   => busy,
		M_AXIS_ACLK	=> m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready
	);

	-- Add user logic here
    
    loadDataReg: process(m00_axis_aclk, m00_axis_aresetn, write)
    begin
        if m00_axis_aresetn = '0' then
            dataRegister <= (others => '1');
        elsif rising_edge(m00_axis_aclk) then
            if write = '1' then
                dataRegister <= dataIn;
            end if;
        end if;
    end process;
	-- User logic ends

end arch_imp;
