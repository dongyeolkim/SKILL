module nand2( out, a, b);
  output out;
  input a, b;
endmodule

module nand3( out, a,b,c);
  output out;
  input a,b,c;
endmodule


module ao222(out, a,b,c);
  output out;
  input a,b,c;
  wire a_nand_b, a_nand_c, b_nand_c;
  nand2 nand_0(a_namd_b, a, b );
  nand2 nand_1(a_namd_c, a, c );
  nand2 nand_2(b_namd_c, b, c );
  nand3 nand_3(out, a_nand_b,a_nand_c, b_nand_c);
endmodule
