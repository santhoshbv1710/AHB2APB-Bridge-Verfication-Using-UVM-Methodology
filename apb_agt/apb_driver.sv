class apb_driver extends uvm_driver #(apb_xtn);
	
	`uvm_component_utils(apb_driver)


	virtual apb_if.APB_DRV vif;
	apb_config cfg;
	bit [31:0]prdata;

	function new(string name = "apb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(apb_config) :: get(this,"","apb_config",cfg))
			`uvm_fatal("APB_DRV","Getting Failed !!!")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
			forever
			
			//	seq_item_port.get_next_item(req);
					send_to_dut();
			//	seq_item_port.item_done();
			
	endtask


	task send_to_dut();
		while(!vif.apb_drv_cb.Pselx)
			@(vif.apb_drv_cb);

	//	while(!vif.apb_drv_cb.Penable)
	//		@(vif.apb_drv_cb);

		if(!vif.apb_drv_cb.Pwrite)
		//if(vif.apb_drv_cb.Penable)
			vif.apb_drv_cb.Prdata <= $random;
	
		repeat(2)
			@(vif.apb_drv_cb);

		`uvm_info("APB_DRV",$sformatf("Printing from apb driver Prdata = %0h",prdata),UVM_LOW)
	
	endtask

endclass
