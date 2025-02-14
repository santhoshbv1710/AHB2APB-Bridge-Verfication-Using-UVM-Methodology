class virtual_sequence extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(virtual_sequence)

	ahb_seqr hseqr;
	apb_seqr pseqr[];

	virtual_sequencer vsqr;

	single_seqs sseqs;
	burst_seqs bseqs;
	apb1_seqs pseqs1;
	env_config cfg;
//	bit [31:0] addr;
	function new(string name = "virtual_sequence");
		super.new(name);
	endfunction

		task body();
			if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",cfg))
				`uvm_fatal("VR_SEQS","Getting failed !!!")
		//	if(!uvm_config_db #(bit[31:0]) :: get(null,get_full_name(),"bit",addr))
		//		`uvm_fatal("VR_SEQS","getting failed")

 			 assert($cast(vsqr,m_sequencer))
				 else 
    					`uvm_error("VR_SEQS_BODY", "Error in $cast of virtual sequencer")
			  
				  hseqr = vsqr.hseqr;
				  pseqr = new[cfg.no_of_agent];
		
				foreach(pseqr[i])
					pseqr[i] = vsqr.pseqr[i];

		endtask

endclass


class single_vseqs extends virtual_sequence;

	`uvm_object_utils(single_vseqs)

	function new(string name = "single_vseqs");
		super.new(name);
	endfunction

	task body();
		super.body();
		sseqs = single_seqs :: type_id :: create("sseqs");
		pseqs1 = apb1_seqs :: type_id :: create("pseqs1");
	fork
		sseqs.start(hseqr);
	//	pseqs1.start(pseqr[0]);
	join
	endtask
endclass

class burst_vseqs extends virtual_sequence;

	`uvm_object_utils(burst_vseqs)

	function new(string name = "burst_vseqs");
		super.new(name);
	endfunction

	task body();

		super.body();

		bseqs = burst_seqs :: type_id :: create("bseqs");
		pseqs1 = apb1_seqs :: type_id :: create("pseqs1");
	fork
		bseqs.start(hseqr);
	//	pseqs1.start(pseqr[0]);
	join

	
	endtask
endclass



