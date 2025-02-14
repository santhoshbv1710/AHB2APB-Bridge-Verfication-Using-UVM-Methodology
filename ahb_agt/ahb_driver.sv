class ahb_driver extends uvm_driver #(ahb_xtn);
	
	`uvm_component_utils(ahb_driver)

	virtual ahb_if.AHB_DRV vif;
	ahb_config cfg;
	function new(string name = "ahb_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(ahb_config) :: get(this,"","ahb_config",cfg))
			`uvm_fatal("AHB_DRV","Getting Failed !!!")
	endfunction

	function void connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.Hresetn <= 0;
		@(vif.ahb_drv_cb);
			vif.ahb_drv_cb.Hresetn <= 1;

		forever
			begin
				seq_item_port.get_next_item(req);
					send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut (ahb_xtn xtn);
		`uvm_info("AHB_DRV",$sformatf("Printing from ahb driver \n %s",xtn.sprint()),UVM_LOW)

		while(!vif.ahb_drv_cb.Hreadyout)
		@(vif.ahb_drv_cb);

		vif.ahb_drv_cb.Hwrite <= xtn.Hwrite;
		vif.ahb_drv_cb.Htrans <= xtn.Htrans;
		vif.ahb_drv_cb.Haddr <= xtn.Haddr;
		vif.ahb_drv_cb.Hsize <= xtn.Hsize;
		vif.ahb_drv_cb.Hreadyin <= 1;

		@(vif.ahb_drv_cb);

		while(!vif.ahb_drv_cb.Hreadyout)
		@(vif.ahb_drv_cb);
	
		if(xtn.Hwrite)
		vif.ahb_drv_cb.Hwdata <= xtn.Hwdata;
		else
			vif.ahb_drv_cb.Hwdata <= 0;
	
	endtask



endclass
