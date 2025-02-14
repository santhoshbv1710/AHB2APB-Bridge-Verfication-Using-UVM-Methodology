class ahb_xtn extends uvm_sequence_item;

	`uvm_object_utils(ahb_xtn)

	rand bit Hwrite;
	rand bit [2:0] Hsize;
	rand bit [1:0] Htrans;
	rand bit [31:0] Haddr;
	rand bit [2:0] Hburst;
	rand bit [31:0] Hwdata;
	bit [31:0] Hrdata;

	rand bit [9:0] length;
	
	//logic [31:0] Hrdata;

	function new(string name = "ahb_xtn");
		super.new(name);
	endfunction
	
	constraint vld_hsize {Hsize inside {[0:2]};}  

	constraint vld_len {(Haddr%1024)+((2**Hsize)*length <= 1024);}

	constraint vld_haddr {Hsize == 1 -> Haddr%2 == 0;
				Hsize == 2 -> Haddr%4 == 0;
				}

	constraint vld_haddr_range {Haddr inside {[32'h8000_0000 : 32'h8000_03ff],
							[32'h8400_0000 : 32'h8400_03ff],
								[32'h8800_0000 : 32'h8800_03ff],
									[32'h8c00_0000 : 32'h8C00_03ff]};
					}

	constraint vld_hburst { Hburst == 2 || Hburst == 3 -> length == 4;
				Hburst == 4 || Hburst == 5 -> length == 8;
				Hburst == 6 || Hburst == 7 -> length == 16;
				}

//	constraint vld_hwrite {Hwrite == 1;}

	function void do_print(uvm_printer printer);
		
		printer.print_field("Haddr",Haddr,32,UVM_HEX);
		printer.print_field("Hwdata",Hwdata,32,UVM_DEC);
		printer.print_field("Hwrite",Hwrite,1,UVM_DEC);
		printer.print_field("Htrans",Htrans,2,UVM_DEC);
		printer.print_field("Hsize",Hsize,2,UVM_DEC);
		printer.print_field("Hburst",Hburst,3,UVM_DEC);
		printer.print_field("Hrdata",Hrdata,32,UVM_HEX);

	endfunction



endclass
