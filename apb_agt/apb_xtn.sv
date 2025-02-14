class apb_xtn extends uvm_sequence_item;


	`uvm_object_utils(apb_xtn)

	bit Penable;
	bit Pwrite;
	bit [31:0] Pwdata;
	bit [31:0] Paddr;
	bit [3:0] Pselx;
	
	rand bit [31:0]Prdata;

	function new(string name = "apb_xtn");
		super.new(name);
	endfunction

	function void do_print(uvm_printer printer);
		
		printer.print_field("Paddr",Paddr,32,UVM_HEX);
		printer.print_field("Penable",Penable,1,UVM_DEC);
		printer.print_field("Pwrite",Pwrite,1,UVM_DEC);
		printer.print_field("Pselx",Pselx,4,UVM_DEC);
		printer.print_field("Prdata",Prdata,32,UVM_HEX);
		printer.print_field("Pwdata",Pwdata,32,UVM_HEX);
		
	endfunction

endclass
