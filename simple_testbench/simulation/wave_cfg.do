onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label reset_n -radix hexadecimal -radixshowbase 0 /testbench/reset_n
add wave -noupdate -label clk -radix hexadecimal -radixshowbase 0 /testbench/clk
add wave -noupdate -label in -radix hexadecimal -radixshowbase 0 /testbench/in
add wave -noupdate -label out -radix hexadecimal -radixshowbase 0 /testbench/out
add wave -noupdate -label posEdgeStr -radix hexadecimal -radixshowbase 0 /testbench/posEdgeStr
add wave -noupdate -label negEdgeStr -radix hexadecimal -radixshowbase 0 /testbench/negEdgeStr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {144827 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 146
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {248086 ps}
