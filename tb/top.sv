module top;

bit clk;
	

	import uvm_pkg::*;	
	import bridge_pkg ::*;
	
always
	#5 clk = ~clk;

	ahb_if hif(clk);
	apb_if pif(clk);

	 rtl_top DUV(.Hclk(clk),
                   .Hresetn(hif.Hresetn),
                   .Htrans(hif.Htrans),
		   .Hsize(hif.Hsize), 
		   .Hreadyin(hif.Hreadyin),
		   .Hwdata(hif.Hwdata), 
		   .Haddr(hif.Haddr),
		   .Hwrite(hif.Hwrite),
                   .Prdata(pif.Prdata),
		   .Hrdata(hif.Hrdata),
		    .Hresp(hif.Hresp),
		    .Hreadyout(hif.Hreadyout),
		    .Pselx(pif.Pselx),
		    .Pwrite(pif.Pwrite),
		    .Penable(pif.Penable), 
		     .Paddr(pif.Paddr),
		   .Pwdata(pif.Pwdata)
		    );	


initial
	begin

		
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
	

		uvm_config_db #(virtual ahb_if) :: set(null,"*","hvif",hif);
		uvm_config_db #(virtual apb_if) :: set(null,"*","pvif",pif);
		run_test();
	end
endmodule
