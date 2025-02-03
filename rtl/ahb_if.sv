interface ahb_if (input bit clk);

	bit Hresetn;
	bit Hwrite;
	bit Hreadyin;
	bit Hreadyout;
	
	bit [2:0]Hsize;
	bit [1:0]Htrans;
	bit [31:0]Haddr;
	bit [2:0]Hburst;
	bit [1:0]Hresp;
	bit [31:0]Hwdata;
	bit [31:0]Hrdata;

	clocking ahb_drv_cb @(posedge clk);
	default input #1 output #1;
		
		output Hresetn;
		output Hwrite;
		output Hreadyin;
		output Haddr;
		output Htrans;
		output Hburst;
		output Hsize;
		output Hwdata;

		input Hreadyout;

	endclocking

	clocking ahb_mon_cb @(posedge clk);
	default input #1 output #1;
		
		input Hresetn;
		input Hwrite;
		input Hreadyin;
		input Haddr;
		input Htrans;
		input Hburst;
		input Hsize;
		input Hwdata;
		input Hrdata;
		input Hreadyout;

	endclocking


	modport AHB_DRV (clocking ahb_drv_cb);
	modport AHB_MON (clocking ahb_mon_cb);

endinterface
	
	
