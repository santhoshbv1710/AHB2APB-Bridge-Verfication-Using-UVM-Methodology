class apb_seqs extends uvm_sequence #(apb_xtn);

	`uvm_object_utils(apb_seqs)

	function new(string name = "apb_seqs");
		super.new(name);
	endfunction
endclass

class apb1_seqs extends apb_seqs;
	
	`uvm_object_utils(apb1_seqs)

	function new(string name = "apb1_seqs");
		super.new(name);
	endfunction

	task body();
		repeat(1)begin
				req = apb_xtn :: type_id :: create("req");
				start_item(req);
				assert(req.randomize() with {Prdata > 0;}); 
				finish_item(req);
			end
	endtask
endclass

