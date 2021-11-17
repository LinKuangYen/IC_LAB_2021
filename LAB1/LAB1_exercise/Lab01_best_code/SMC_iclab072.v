module SMC(
  // Input signals
    mode,
    W_0, V_GS_0, V_DS_0,
    W_1, V_GS_1, V_DS_1,
    W_2, V_GS_2, V_DS_2,
    W_3, V_GS_3, V_DS_3,
    W_4, V_GS_4, V_DS_4,
    W_5, V_GS_5, V_DS_5,
  // Output signals
    out_n
);

input [2:0] W_0, V_GS_0, V_DS_0;
input [2:0] W_1, V_GS_1, V_DS_1;
input [2:0] W_2, V_GS_2, V_DS_2;
input [2:0] W_3, V_GS_3, V_DS_3;
input [2:0] W_4, V_GS_4, V_DS_4;
input [2:0] W_5, V_GS_5, V_DS_5;
input [1:0] mode;
output [9:0] out_n; 

/* INITIALIZATION */
reg [2:0] V_GS[0:5];
reg [2:0] V_DS[0:5];
reg [2:0] W[0:5];

always@(*) begin
	V_GS[0] = V_GS_0;	V_DS[0] = V_DS_0;	W[0] = W_0;	
	V_GS[1] = V_GS_1;	V_DS[1] = V_DS_1;	W[1] = W_1;
	V_GS[2] = V_GS_2;	V_DS[2] = V_DS_2;	W[2] = W_2;
	V_GS[3] = V_GS_3;	V_DS[3] = V_DS_3;	W[3] = W_3;
	V_GS[4] = V_GS_4;	V_DS[4] = V_DS_4;	W[4] = W_4;
	V_GS[5] = V_GS_5;	V_DS[5] = V_DS_5;	W[5] = W_5;
end

/* CALCULATING */
reg [2:0] sub1_V_GS[0:5];
reg Comp_GS_DS[0:5];
reg [3:0] sub1_mul2_V_GS[0:5];
reg [2:0] Gmn_mul_choose[0:5];
reg [3:0] Idn_mul_choose[0:5];
reg [3:0] choose[0:5]; 
reg [3:0] Gmn_Idn_part0_tmp[0:5];
reg [4:0] Gmn_Idn_part1_tmp[0:5];
reg [5:0] Gmn_Idn_part2_tmp[0:5];
reg [5:0] Gmn_Idn_part[0:5];
reg [5:0] Gmn_Idn0_tmp[0:5];
reg [6:0] Gmn_Idn1_tmp[0:5];
reg [7:0] Gmn_Idn2_tmp[0:5];
reg [7:0] Gmn_Idn_part2[0:5];
reg [6:0] Gmn_Idn[0:5];
integer i;

always@(*) begin
	for(i=0; i<=5; i=i+1) begin
		/* V_GS minus one with kmap */
		sub1_V_GS[i][2] = V_GS[i][2] & (V_GS[i][1] | V_GS[i][0]); 
		sub1_V_GS[i][1] = ~(V_GS[i][1] ^ V_GS[i][0]);
		sub1_V_GS[i][0] = ~V_GS[i][0];
		
		/* (V_GS_n - 1 > V_DS_n) or not */
		Comp_GS_DS[i] = sub1_V_GS[i] > V_DS[i] ? 1'b1 : 1'b0;
		/* (V_GS_n - 1) * 2 */
		sub1_mul2_V_GS[i] = {sub1_V_GS[i], 1'b0};
		/* Choose multiplicand with Comp_GS_DS */
		Gmn_mul_choose[i] = (Comp_GS_DS[i]) ? V_DS[i] : sub1_V_GS[i];
		Idn_mul_choose[i] = (Comp_GS_DS[i]) ? sub1_mul2_V_GS[i] - V_DS[i] : sub1_V_GS[i];
		
		/* Choose multiplier with mode[0] */
		choose[i] = (mode[0]) ? Idn_mul_choose[i] : 4'd2;
		
		/* Gmn_Idn_part = choose * Gmn_mul_choose */
		Gmn_Idn_part0_tmp[i] = Gmn_mul_choose[i][0] ? choose[i] : 4'd0;
		Gmn_Idn_part1_tmp[i] = Gmn_mul_choose[i][1] ? {choose[i], 1'b0} : 5'd0;
		Gmn_Idn_part2_tmp[i] = Gmn_mul_choose[i][2] ? {choose[i], 2'b0} : 6'd0;
		Gmn_Idn_part[i] = Gmn_Idn_part0_tmp[i] + Gmn_Idn_part1_tmp[i] + Gmn_Idn_part2_tmp[i];
		
		/* Gmn_Idn_part2 = W * Gmn_Idn_part */
		Gmn_Idn0_tmp[i] = (W[i][0]) ? Gmn_Idn_part[i] : 6'd0;
		Gmn_Idn1_tmp[i] = (W[i][1]) ? {Gmn_Idn_part[i], 1'b0} : 7'd0;
		Gmn_Idn2_tmp[i] = (W[i][2]) ? {Gmn_Idn_part[i], 2'b0} : 8'd0;
		Gmn_Idn_part2[i] = Gmn_Idn0_tmp[i] + Gmn_Idn1_tmp[i] + Gmn_Idn2_tmp[i];
		
		/* Divide 3 */
		Gmn_Idn[i] = Gmn_Idn_part2[i] / 3;
	end
end

/* SORTING */
reg [6:0] a0, a1, a2, a3, a4, a5;
reg [6:0] b0, b1, b2, b3, b4, b5;
reg [6:0] c0, c1, c2, c3, c4, c5;
reg [6:0] d0, d1, d2, d3, e0, e1;

always@(*) begin
	a0 = (Gmn_Idn[0] > Gmn_Idn[1]) ? Gmn_Idn[0] : Gmn_Idn[1];
	a1 = (Gmn_Idn[0] > Gmn_Idn[1]) ? Gmn_Idn[1] : Gmn_Idn[0];
	a2 = (Gmn_Idn[2] > Gmn_Idn[3]) ? Gmn_Idn[2] : Gmn_Idn[3];
	a3 = (Gmn_Idn[2] > Gmn_Idn[3]) ? Gmn_Idn[3] : Gmn_Idn[2];
	a4 = (Gmn_Idn[4] > Gmn_Idn[5]) ? Gmn_Idn[4] : Gmn_Idn[5];
	a5 = (Gmn_Idn[4] > Gmn_Idn[5]) ? Gmn_Idn[5] : Gmn_Idn[4];
	b0 = (a0 > a2) ? a0 : a2;
	b1 = (a0 > a2) ? a2 : a0;
	b2 = (a1 > a4) ? a1 : a4;
	b3 = (a1 > a4) ? a4 : a1;
	b4 = (a3 > a5) ? a3 : a5;
	b5 = (a3 > a5) ? a5 : a3;
	c0 = (b0 > b2) ? b0 : b2;
	c1 = (b0 > b2) ? b2 : b0;
	c2 = (b1 > b4) ? b1 : b4;
	c3 = (b1 > b4) ? b4 : b1;
	c4 = (b3 > b5) ? b3 : b5;
	c5 = (b3 > b5) ? b5 : b3;
	d0 = (c1 > c2) ? c1 : c2;
	d1 = (c1 > c2) ? c2 : c1;
	d2 = (c3 > c4) ? c3 : c4;
	d3 = (c3 > c4) ? c4 : c3;
	e0 = (d1 > d2) ? d1 : d2;
	e1 = (d1 > d2) ? d2 : d1;
end

/* OUTPUT */
wire [6:0] out1 = mode[1] ? c0 : e1;
wire [6:0] out2 = mode[1] ? d0 : d3;
wire [6:0] out3 = mode[1] ? e0 : c5;
wire [7:0] outp1 = (mode[0]) ? {out1, 1'b0} : 8'd0;
wire [8:0] outp2 = (mode[0]) ? {out2, 2'b0} : out2;
wire [8:0] outp3 = (mode[0]) ? {out3, 2'b0} : 9'd0;
assign out_n = outp1 + outp2 + outp3 + out1 + out3;

endmodule

