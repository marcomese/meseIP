library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package utilsPkg is
    function log2(n : positive) return integer;
end package;

package body utilsPkg is
    function log2(n: positive) return integer is
        variable nV  : integer := n;
        variable cnt : integer := 0;
    begin
        for i in 0 to n loop
            if nV <= 1 then
                return cnt;
            else
                nV := nV / 2;
                cnt := cnt+1;
            end if;
        end loop;
    end function;
end package body;