class apb_monitor extends uvm_monitor;
	
	`uvm_component_utils(apb_monitor)

	virtual apb_if.APB_MON vif;
	apb_config cfg;

		uvm_analysis_port #(apb_xtn) monitor_port;

	function new(string name = "apb_monitor",uvm_component parent);
		super.new(name,parent);
			monitor_port = new("monitor port",this);

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
		collect_data();
	endtask

	task collect_data();
		apb_xtn xtn;
		xtn = apb_xtn :: type_id :: create("xtn");

		while(!vif.apb_mon_cb.Penable)
			@(vif.apb_mon_cb);

		xtn.Pselx = vif.apb_mon_cb.Pselx;
		xtn.Pwrite = vif.apb_mon_cb.Pwrite;
		xtn.Paddr = vif.apb_mon_cb.Paddr;
		xtn.Penable = vif.apb_mon_cb.Penable;
	
		if(xtn.Pwrite)
			xtn.Pwdata = vif.apb_mon_cb.Pwdata;
		else
			xtn.Prdata = vif.apb_mon_cb.Prdata;
			

		@(vif.apb_mon_cb);

			`uvm_info("APB_MON",$sformatf("Printing from apb monitor \n %s",xtn.sprint()),UVM_LOW)

		monitor_port.write(xtn);

	endtask 


endclass
