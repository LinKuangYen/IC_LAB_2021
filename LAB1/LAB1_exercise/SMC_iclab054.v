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

  //================================================================
  //   INPUT AND OUTPUT DECLARATION
  //================================================================
  input [2:0] W_0, V_GS_0, V_DS_0;
  input [2:0] W_1, V_GS_1, V_DS_1;
  input [2:0] W_2, V_GS_2, V_DS_2;
  input [2:0] W_3, V_GS_3, V_DS_3;
  input [2:0] W_4, V_GS_4, V_DS_4;
  input [2:0] W_5, V_GS_5, V_DS_5;
  input [1:0] mode;
  //output [8:0] out_n;         							// use this if using continuous assignment for out_n  // Ex: assign out_n = XXX;
  output wire [9:0] out_n; 								// use this if using procedure assignment for out_n   // Ex: always@(*) begin out_n = XXX; end

  //================================================================
  //    Wire & Registers
  //================================================================
  // Declare the wire/reg you would use in your circuit
  // remember
  // wire for port connection and cont. assignment
  // reg for proc. assignment

  wire [6:0] ig_0,ig_1,ig_2,ig_3,ig_4,ig_5;
  reg [6:0] d_0,d_1,d_2,d_3,d_4,d_5;
  reg [6:0] t0_0,t0_1,t0_2,t0_3,t0_4,t0_5,t1_0,t1_1,t1_2,t1_3,n0,t2_0,t2_1,n5,t3_0,t3_1,t3_2,t3_3,n1,t4_0,t4_1,n2,n3,n4;
  wire [2:0] c_0,c_1,c_2,c_3,c_4,c_5;
  reg [6:0] a,b,c;

  //================================================================
  //    DESIGN
  //================================================================
  // --------------------------------------------------
  // write your design here
  // --------------------------------------------------
  assign c_0 = V_GS_0 - 1;
  assign c_1 = V_GS_1 - 1;
  assign c_2 = V_GS_2 - 1;
  assign c_3 = V_GS_3 - 1;
  assign c_4 = V_GS_4 - 1;
  assign c_5 = V_GS_5 - 1;

  always@(*)
  begin
    //-------------------------
    //id,gm calculation
    //-------------------------
    if(mode[0] == 1'b1)
    begin
      //id_0
      if( c_0 > V_DS_0 )
        d_0 = V_DS_0*(2*c_0-V_DS_0) ;
      else
        d_0 = c_0*c_0;
      //id_1
      if( c_1 > V_DS_1 )
        d_1 = V_DS_1*(2*c_1-V_DS_1) ;
      else
        d_1 = c_1*c_1;
      //id_2
      if( c_2 > V_DS_2 )
        d_2 = V_DS_2*(2*c_2-V_DS_2) ;
      else
        d_2 = c_2*c_2;
      //id_3
      if( c_3 > V_DS_3 )
        d_3 = V_DS_3*(2*c_3-V_DS_3) ;
      else
        d_3 = c_3*c_3;
      //id_4
      if( c_4 > V_DS_4 )
        d_4 = V_DS_4*(2*c_4-V_DS_4) ;
      else
        d_4 = c_4*c_4;
      //id_5
      if( c_5 > V_DS_5 )
        d_5 = V_DS_5*(2*c_5-V_DS_5) ;
      else
        d_5 = c_5*c_5;
    end
    else
    begin
      //gm_0
      if( c_0 > V_DS_0 )
        d_0 = 2*V_DS_0 ;
      else
        d_0 = 2*c_0 ;
      //gm_1
      if( c_1 > V_DS_1 )
        d_1 = 2*V_DS_1 ;
      else
        d_1 = 2*c_1 ;
      //gm_2
      if( c_2 > V_DS_2 )
        d_2 = 2*V_DS_2 ;
      else
        d_2 = 2*c_2 ;
      //gm_3
      if( c_3 > V_DS_3 )
        d_3 = 2*V_DS_3 ;
      else
        d_3 = 2*c_3 ;
      //gm_4
      if( c_4 > V_DS_4 )
        d_4 = 2*V_DS_4 ;
      else
        d_4 = 2*c_4 ;
      //gm_4
      if( c_5 > V_DS_5 )
        d_5 = 2*V_DS_5;
      else
        d_5 = 2*c_5 ;

    end
  end

  assign ig_0 = W_0*d_0/3;
  assign ig_1 = W_1*d_1/3;
  assign ig_2 = W_2*d_2/3;
  assign ig_3 = W_3*d_3/3;
  assign ig_4 = W_4*d_4/3;
  assign ig_5 = W_5*d_5/3;
  //-------------------------
  //sorting
  //-------------------------
  always @(*)
  begin

    if(ig_0 > ig_1)
    begin
      t0_0 = ig_0;
      t0_1 = ig_1;
    end
    else
    begin
      t0_0 = ig_1;
      t0_1 = ig_0;
    end

    if(ig_2 > ig_3)
    begin
      t0_2 = ig_2;
      t0_3 = ig_3;
    end
    else
    begin
      t0_2 = ig_3;
      t0_3 = ig_2;
    end

    if(ig_4 > ig_5)
    begin
      t0_4 = ig_4;
      t0_5 = ig_5;
    end
    else
    begin
      t0_4 = ig_5;
      t0_5 = ig_4;
    end

    if(t0_0 > t0_2)
    begin
      t1_0 = t0_0;
      t1_1 = t0_2;
    end
    else
    begin
      t1_0 = t0_2;
      t1_1 = t0_0;
    end

    if(t0_3 > t0_5)
    begin
      t1_2 = t0_3;
      t1_3 = t0_5;
    end
    else
    begin
      t1_2 = t0_5;
      t1_3 = t0_3;
    end

    if(t1_0 > t0_4)
    begin
      n0 = t1_0;
      t2_0 = t0_4;
    end
    else
    begin
      n0 = t0_4;
      t2_0 = t1_0;
    end

    if(t0_1 > t1_3)
    begin
      t2_1 = t0_1;
      n5 = t1_3;
    end
    else
    begin
      t2_1 = t1_3;
      n5 = t0_1;
    end
    //q8
    if(t2_0 > t1_1)
    begin
      t3_0 = t2_0;
      t3_1 = t1_1;
    end
    else
    begin
      t3_0 = t1_1;
      t3_1 = t2_0;
    end
    //q9
    if(t1_2 > t2_1)
    begin
      t3_2 = t1_2;
      t3_3 = t2_1;
    end
    else
    begin
      t3_2 = t2_1;
      t3_3 = t1_2;
    end
    //q10
    if(t3_0 > t3_2)
    begin
      n1 = t3_0;
      t4_0 = t3_2;
    end
    else
    begin
      n1 = t3_2;
      t4_0 = t3_0;
    end
    //q11
    if(t3_1 > t3_3)
    begin
      t4_1 = t3_1;
      n4 = t3_3;
    end
    else
    begin
      t4_1 = t3_3;
      n4 = t3_1;
    end
    //q12
    if(t4_0 > t4_1)
    begin
      n2 = t4_0;
      n3 = t4_1;
    end
    else
    begin
      n2 = t4_1;
      n3 = t4_0;
    end
  end
  //-------------------------
  //out calculation
  //-------------------------
  always @(*)
  begin
    if(mode[0] == 1)
    begin
      if(mode[1] == 1)
      begin
        a = n0;
        b = n1;
        c = n2;
      end
      else
      begin
        a = n3;
        b = n4;
        c = n5;
      end
    end
    else
    begin
      if(mode[1] == 1)
      begin
        a = n0;
        b = n1;
        c = n2;
      end
      else
      begin
        a = n3;
        b = n4;
        c = n5;
      end
    end
  end

  assign out_n = (mode[0]) ? 3*a + 4*b + 5*c :a + b + c;

endmodule








//================================================================
//   SUB MODULE
//================================================================


// module BBQ (meat,vagetable,water,cost);
// input XXX;
// output XXX;
//
// endmodule

// --------------------------------------------------
// Example for using submodule
// BBQ bbq0(.meat(meat_0), .vagetable(vagetable_0), .water(water_0),.cost(cost[0]));
// --------------------------------------------------
// Example for continuous assignment
// assign out_n = XXX;
// --------------------------------------------------
// Example for procedure assignment
// always@(*) begin
// 	out_n = XXX;
// end
// --------------------------------------------------
// Example for case statement
// always @(*) begin
// 	case(op)
// 		2'b00: output_reg = a + b;
// 		2'b10: output_reg = a - b;
// 		2'b01: output_reg = a * b;
// 		2'b11: output_reg = a / b;
// 		default: output_reg = 0;
// 	endcase
// end
// --------------------------------------------------
