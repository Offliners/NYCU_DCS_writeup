`define CYCLE_TIME 8.0

module PATTERN(
    clk, 
	rst_n, 
	// input 
	i_valid, 
	i_length,
	m_ready,
	// virtual memory
	m_data,
	m_read,
	m_addr,
	// output 
	o_valid, 
	o_data 
);

//---------------------------------------------------------------------
//   PORT DECLARATION
//----------- ---------------------------------------------------------
output logic        clk, rst_n; 
// input            
output logic        i_valid; 
output logic  [1:0] i_length;
output logic        m_ready;
// virtual memory
output logic [31:0] m_data; 
input         		m_read;
input   	  [5:0] m_addr; 
// output 
input               o_valid; 
input 		 [40:0] o_data; 

//================================================================
// clock
//================================================================
real	CYCLE = `CYCLE_TIME;
always	#(CYCLE/2.0) clk = ~clk;

//================================================================
// parameters & integer
//================================================================
integer PATNUM = 250;
integer seed = 18;
integer i, j, k;
integer patcount;
integer cycle_gap;
integer lat_exe, lat_mem;
integer latency, out_latency, total_latency; 

integer o_valid_cnt;

logic [5:0] rand_color; 
 
integer temp_int; 
integer rand_num, fp;

// virtual memory supports random reading and writting
logic m_valid;
integer length;
logic [31:0] V_RAM      [0:63];

logic  [3:0] I_MTX [0:31][0:7]; 
logic  [3:0] WQ_MTX [0:7][0:7];
logic  [3:0] WK_MTX [0:7][0:7];
logic  [3:0] WV_MTX [0:7][0:7];

// bit-width revise, by 謝
logic [29:0] sum   [0:31];
logic [29:0] avg   [0:31];
logic  [3:0] i_mtx [0:31][0:7]; // after RAT

logic [10:0] q_mtx [0:31][0:7];  // after WQ
logic [10:0] k_mtx [0:31][0:7];  // after WK 
logic [10:0] v_mtx [0:31][0:7];  // after WV

logic [24:0] s_mtx [0:31][0:31];

logic [40:0] O_MTX [0:31][0:7]; 




//================================================================
// initial
//================================================================
initial begin
    forever begin
        @(negedge clk);
		if (m_valid == 0) begin
			m_data = 'dx;
			lat_mem = 0;
		end
		else begin
			if (m_read === 1 && m_valid === 1) begin
				m_data = V_RAM[m_addr];  // Fetch data from memory
				lat_mem = lat_mem + 1;
			end else begin
				m_data = 'dx;            // High-impedance or undefined when not reading
				lat_mem = lat_mem;
			end	
		end
    end
end

initial begin
	m_valid = 0;
	RESET_TASK; 
	lat_exe = 0;
	total_latency = 0; 
	
	@(negedge clk); 
	for(patcount=0; patcount<PATNUM; patcount=patcount+1)
	begin  
		lat_exe = 0;
		INPUT_TASK;
		READY_TASK;
		m_valid = 1;
		WAIT_O_VALID; 
		CHECK_ANS; 
		m_valid = 0;

		rand_color = 31 + patcount % 7;
		$display("\033[%dmPass Pattern No. %3d , latency for memory fetching = %2d cycles, latency for execution = %2d cycles\033[m", rand_color, patcount, lat_mem, lat_exe);
		total_latency += (3 * lat_mem + lat_exe); 
		repeat($urandom_range(2, 5)) @(negedge clk);
	end

	repeat(5) @(negedge clk); 

    // PASS task
	YOU_PASS_task; 
	$finish;
end

// check overlapping: o_valid / i_valid
always begin
    @(negedge clk); 
    if(o_valid === 1'b1 && i_valid === 1'b1 ) begin
        fail;
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        $display ("                                                  OUTPUT FAIL!                                                            ");
        $display ("                                      o_valid can NOT overlap with i_valid                                                ");
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        #(4*CYCLE);
	    $finish ;
    end
end

// check overlapping: m_read / i_valid
always begin
    @(negedge clk); 
    if(m_read === 1'b1 && i_valid === 1'b1 ) begin
        fail;
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        $display ("                                              Reading Request FAIL!                                                       ");
        $display ("                                      m_read  can NOT overlap with i_valid                                                ");
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        #(4*CYCLE);
	    $finish ;
    end
end

// check overlapping: m_read / m_ready
always begin
	@(negedge clk);
	if(m_read === 1'b1 && m_ready === 1'b1) begin
        fail;
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        $display ("                                              Reading Request FAIL!                                                       ");
        $display ("                                      m_read  can NOT overlap with m_ready                                                ");
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        #(4*CYCLE);
	    $finish ;	
	end
end

// check overlapping: m_read / o_valid
always begin
	@(negedge clk);
	if(m_read === 1'b1 && o_valid === 1'b1) begin
        fail;
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        $display ("                                              Reading Request FAIL!                                                       ");
        $display ("                                      m_read  can NOT overlap with o_valid                                                ");
        $display ("--------------------------------------------------------------------------------------------------------------------------");
        #(4*CYCLE);
	    $finish ;	
	end
end

//================================================================
// task
//================================================================
task RESET_TASK; begin
	clk = 1'b0;
	rst_n = 1'b1; 
	i_valid = 1'b0; 
	i_length = 'dx;
	m_ready = 1'b0;
	for (i = 0; i < 64; i++) begin
		for (j = 0; j < 32; j++) begin
			V_RAM[i][j] = 'dx;
		end
	end

	force clk = 0;
	#(0.5*CYCLE); rst_n = 1'b0; 
	#(3.0*CYCLE); 
	// check reset for all the output signals, including m_read, o_valid, and o_data
	if(m_read !== 1'b0 || o_valid !== 1'b0 || o_data !== 'd0) begin
		fail;
		$display ("--------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                  RESET FAIL!                                                             ");
		$display ("                                          All outputs should be reset                                                     ");
		$display ("--------------------------------------------------------------------------------------------------------------------------");
		#(10*CYCLE);
	    $finish ;
	end

	rst_n = 1'b1; 
	#(5.0*CYCLE); release clk; 
end endtask

task INPUT_TASK; begin
	// input matrix
	@(negedge clk); 
	i_valid = 1'b1; 
	i_length = $urandom_range(0,3);
	length = 1 << (2+i_length); // token length

	for (i = 0; i < 32; i++) begin
		if (i < length) begin
			for (j = 0; j < 8; j++) begin
				I_MTX[i][j] = $urandom_range(0, 15);
			end
		end
		else begin
			for (j = 0; j < 8; j++) begin
				I_MTX[i][j] = 'd0;
			end
		end
	end

	for (i = 0; i < 8; i++) begin
		for (j = 0; j < 8; j++) begin
			WQ_MTX[i][j] = $urandom_range(0, 15);
			WK_MTX[i][j] = $urandom_range(0, 15);
			WV_MTX[i][j] = $urandom_range(0, 15);
		end
	end

	for(i = 0; i < 64; i++) begin
		if (i < length) begin
			for (j = 0; j < 8; j++) begin
				V_RAM[i][4*j +: 4] = I_MTX[i][j]; 
			end
		end
		else 
		if (length <= i && i < (length + 8)) begin
			for (j = 0; j < 8; j++) begin
				V_RAM[i][4*j +: 4] = WQ_MTX[j][i - length]; // WQ stored in column oredreing 
			end
		end
		else 
		if ((length + 8) <= i && i < (length + 16)) begin
			for (j = 0; j < 8; j++) begin
				V_RAM[i][4*j +: 4] = WK_MTX[j][i - (length + 8)];  // WK stored in column ordering 
			end
		end
		else 
		if ((length + 16) <= i && i < (length + 24)) begin
			for (j = 0; j < 8; j++) begin
				V_RAM[i][4*j +: 4] = WV_MTX[j][i - (length + 16)]; // WV stored in column ordering 
			end
		end
		else begin
			for (j = 0; j < 8; j++) begin
				V_RAM[i][4*j +: 4] = 'dx;
			end
		end
	end
	// RAT
	for (i = 0 ; i < 32 ; i++) begin
		sum[i] = 0;
		avg[i] = 0;
		for (j = 0 ; j < 8 ; j = j + 1) begin
			sum[i] = sum[i] + I_MTX[i][j];
		end
		avg[i] = sum[i] / 8;
	end
	for (i = 0 ; i < 32 ; i = i + 1) begin
		for (j = 0 ; j < 8 ; j = j + 1) begin
			if (I_MTX[i][j] < avg[i]) begin
				i_mtx[i][j] = 0;
			end
			else begin
				i_mtx[i][j] = I_MTX[i][j];
			end
		end
	end
	// after WQ, WK, WV
	for (i = 0; i < 32; i++) begin
		for (j = 0; j < 8; j++) begin
			q_mtx[i][j] = 'd0;
			k_mtx[i][j] = 'd0;
			v_mtx[i][j] = 'd0;
			for (k = 0; k < 8; k++) begin
				q_mtx[i][j] = q_mtx[i][j] + i_mtx[i][k] * WQ_MTX[k][j];
				k_mtx[i][j] = k_mtx[i][j] + i_mtx[i][k] * WK_MTX[k][j];
				v_mtx[i][j] = v_mtx[i][j] + i_mtx[i][k] * WV_MTX[k][j];
			end
		end
	end
	// scores 
	for (i = 0; i < 32; i++) begin
		for (j = 0; j < 32; j++) begin
			s_mtx[i][j] = 'd0;
			for (k = 0; k < 8; k++) begin
				s_mtx[i][j] = s_mtx[i][j] + q_mtx[i][k] * k_mtx[j][k];
			end
		end
	end
	// CAT
	for (i = 0 ; i < 32 ; i++) begin
		sum[i] = 0;
		avg[i] = 0;
		for (j = 0 ; j < 32 ; j = j + 1) begin
			sum[i] = sum[i] + s_mtx[j][i];
		end
		avg[i] = sum[i] / length;
	end
	for (i = 0 ; i < 32 ; i = i + 1) begin
		for (j = 0 ; j < 32 ; j = j + 1) begin
			if (s_mtx[i][j] < avg[j]) begin
				s_mtx[i][j] = 0;
			end
			else begin
				s_mtx[i][j] = s_mtx[i][j];
			end
		end
	end
	// output
	for (i = 0; i < 32; i++) begin
		for (j = 0; j < 8; j++) begin
			O_MTX[i][j] = 'd0;
			for (k = 0; k < 32; k++) begin
				O_MTX[i][j] = O_MTX[i][j] + s_mtx[i][k] * v_mtx[k][j];
			end
		end
	end
	
	@(negedge clk);
	i_valid = 1'b0;
	i_length = 'dx;
	lat_exe = lat_exe + 1;

end endtask 

task READY_TASK; begin
	cycle_gap = $urandom_range(2, 5);
	repeat(cycle_gap) @(negedge clk);
	m_ready = 1'b1;
	@(negedge clk);
	m_ready = 1'b0;	
	lat_exe = lat_exe + (cycle_gap + 1);
end endtask

task WAIT_O_VALID; begin
	// check whether execution time is longer than the limitation or not
	latency = 0; 
	while(o_valid !== 1'b1) begin
		@(negedge clk); 
		latency += 1; 
		if(latency >= 10000) begin
			fail;
			$display ("--------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                  OUTPUT FAIL!                                                            ");
			$display ("                                  Latency should not be longer than 10000 cycles                                           ");
			$display ("--------------------------------------------------------------------------------------------------------------------------");
			#(10*CYCLE);
			$finish;
		end
	end
	lat_exe = lat_exe + latency;
end endtask

task CHECK_ANS; begin
	o_valid_cnt = 0;
	while(o_valid === 1) begin
		if(o_valid_cnt === 8)begin
			fail;
			$display ("-------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                              FAIL!                                                                  ");
			$display ("                                                         Pattern No. %3d                                                             ", patcount);
			$display ("                                                Output should be last only for 8 cycles                                              ");
			$display ("-------------------------------------------------------------------------------------------------------------------------------------");
			#(100);
			$finish ;		
		end
		if (o_data !== O_MTX[length-1][o_valid_cnt]) begin
			fail;
			REPORT_GOLDEN_ANSWER;
			$display ("-------------------------------------------------------------------------------------------------------------------------------------");
			$display ("                                                               FAIL!                                                                 ");
			$display ("                                                         Pattern No. %3d                                                             ", patcount);
			$display ("                                         ERROR occurs at the %3d th element of the output vector                                     ", o_valid_cnt);
			$display ("                                                         YOUR answer : %d                                                            ", o_data);
			$display ("                                                       GOLDEN answer : %d                                                            ", O_MTX[length-1][o_valid_cnt]);
			$display ("-------------------------------------------------------------------------------------------------------------------------------------");
			#(100);
			$finish;			
		end
		o_valid_cnt = o_valid_cnt + 1;
		@(negedge clk);
	end
	if(o_valid_cnt !== 8)begin
		fail;
		$display ("-------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                              FAIL!                                                                  ");
		$display ("                                                         Pattern No. %3d                                                             ", patcount);
		$display ("                                                Output should be last only for 8 cycles                                              ");
		$display ("-------------------------------------------------------------------------------------------------------------------------------------");
		#(100);
		$finish ;		
	end
	o_valid_cnt = 0;
end endtask

task YOU_PASS_task;begin
    $display("\033[37m                                                                                                                                          ");        
    $display("\033[37m                                                                                \033[32m      :BBQvi.                                              ");        
    $display("\033[37m                                                              .i7ssrvs7         \033[32m     BBBBBBBBQi                                           ");        
    $display("\033[37m                        .:r7rrrr:::.        .::::::...   .i7vr:.      .B:       \033[32m    :BBBP :7BBBB.                                         ");        
    $display("\033[37m                      .Kv.........:rrvYr7v7rr:.....:rrirJr.   .rgBBBBg  Bi      \033[32m    BBBB     BBBB                                         ");        
    $display("\033[37m                     7Q  :rubEPUri:.       ..:irrii:..    :bBBBBBBBBBBB  B      \033[32m   iBBBv     BBBB       vBr                               ");        
    $display("\033[37m                    7B  BBBBBBBBBBBBBBB::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB :R     \033[32m   BBBBBKrirBBBB.     :BBBBBB:                            ");        
    $display("\033[37m                   Jd .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: Bi    \033[32m  rBBBBBBBBBBBR.    .BBBM:BBB                             ");        
    $display("\033[37m                  uZ .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .B    \033[32m  BBBB   .::.      EBBBi :BBU                             ");        
    $display("\033[37m                 7B .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  B    \033[32m MBBBr           vBBBu   BBB.                             ");        
    $display("\033[37m                .B  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: JJ   \033[32m i7PB          iBBBBB.  iBBB                              ");        
    $display("\033[37m                B. BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  Lu             \033[32m  vBBBBPBBBBPBBB7       .7QBB5i                ");        
    $display("\033[37m               Y1 KBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBi XBBBBBBBi :B            \033[32m :RBBB.  .rBBBBB.      rBBBBBBBB7              ");        
    $display("\033[37m              :B .BBBBBBBBBBBBBsRBBBBBBBBBBBrQBBBBB. UBBBRrBBBBBBr 1BBBBBBBBB  B.          \033[32m    .       BBBB       BBBB  :BBBB             ");        
    $display("\033[37m              Bi BBBBBBBBBBBBBi :BBBBBBBBBBE .BBK.  .  .   QBBBBBBBBBBBBBBBBBB  Bi         \033[32m           rBBBr       BBBB    BBBU            ");        
    $display("\033[37m             .B .BBBBBBBBBBBBBBQBBBBBBBBBBBB       \033[38;2;242;172;172mBBv \033[37m.LBBBBBBBBBBBBBBBBBBBBBB. B7.:ii:   \033[32m           vBBB        .BBBB   :7i.            ");        
    $display("\033[37m            .B  PBBBBBBBBBBBBBBBBBBBBBBBBBBBBbYQB. \033[38;2;242;172;172mBB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBB  Jr:::rK7 \033[32m             .7  BBB7   iBBBg                  ");        
    $display("\033[37m           7M  PBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBB. \033[37mBBBBBBBBBBBBBBBBBBBBBBB..i   .   v1                  \033[32mdBBB.   5BBBr                 ");        
    $display("\033[37m          sZ .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBB. \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBB iD2BBQL.                 \033[32m ZBBBr  EBBBv     YBBBBQi     ");        
    $display("\033[37m  .7YYUSIX5 .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBB. \033[37mBBBBBBBBBBBBBBBBBBBBBBBBY.:.      :B                 \033[32m  iBBBBBBBBD     BBBBBBBBB.   ");        
    $display("\033[37m LB.        ..BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB. \033[38;2;242;172;172mBB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBMBBB. BP17si                 \033[32m    :LBBBr      vBBBi  5BBB   ");        
    $display("\033[37m  KvJPBBB :BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: \033[38;2;242;172;172mZB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBsiJr .i7ssr:                \033[32m          ...   :BBB:   BBBu  ");        
    $display("\033[37m i7ii:.   ::BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBj \033[38;2;242;172;172muBi \033[37mQBBBBBBBBBBBBBBBBBBBBBBBBi.ir      iB                \033[32m         .BBBi   BBBB   iMBu  ");        
    $display("\033[37mDB    .  vBdBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBg \033[38;2;242;172;172m7Bi \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBBB rBrXPv.                \033[32m          BBBX   :BBBr        ");        
    $display("\033[37m :vQBBB. BQBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBQ \033[38;2;242;172;172miB: \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .L:ii::irrrrrrrr7jIr   \033[32m          .BBBv  :BBBQ        ");        
    $display("\033[37m :7:.   .. 5BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mBr \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBB:            ..... ..YB. \033[32m           .BBBBBBBBB:        ");        
    $display("\033[37mBU  .:. BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  \033[38;2;242;172;172mB7 \033[37mgBBBBBBBBBBBBBBBBBBBBBBBBBB. gBBBBBBBBBBBBBBBBBB. BL \033[32m             rBBBBB1.         ");        
    $display("\033[37m rY7iB: BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: \033[38;2;242;172;172mB7 \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBB. QBBBBBBBBBBBBBBBBBi  v5                                ");        
    $display("\033[37m     us EBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB \033[38;2;242;172;172mIr \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBgu7i.:BBBBBBBr Bu                                 ");        
    $display("\033[37m      B  7BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB.\033[38;2;242;172;172m:i \033[37mBBBBBBBBBBBBBBBBBBBBBBBBBBBv:.  .. :::  .rr    rB                                  ");        
    $display("\033[37m      us  .BBBBBBBBBBBBBQLXBBBBBBBBBBBBBBBBBBBBBBBBq  .BBBBBBBBBBBBBBBBBBBBBBBBBv  :iJ7vri:::1Jr..isJYr                                   ");        
    $display("\033[37m      B  BBBBBBB  MBBBM      qBBBBBBBBBBBBBBBBBBBBBB: BBBBBBBBBBBBBBBBBBBBBBBBBB  B:           iir:                                       ");        
    $display("\033[37m     iB iBBBBBBBL       BBBP. :BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  B.                                                       ");        
    $display("\033[37m     P: BBBBBBBBBBB5v7gBBBBBB  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: Br                                                        ");        
    $display("\033[37m     B  BBBs 7BBBBBBBBBBBBBB7 :BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .B                                                         ");        
    $display("\033[37m    .B :BBBB.  EBBBBBQBBBBBJ .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB. B.                                                         ");        
    $display("\033[37m    ij qBBBBBg          ..  .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB .B                                                          ");        
    $display("\033[37m    UY QBBBBBBBBSUSPDQL...iBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBK EL                                                          ");        
    $display("\033[37m    B7 BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB: B:                                                          ");        
    $display("\033[37m    B  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBYrBB vBBBBBBBBBBBBBBBBBBBBBBBB. Ls                                                          ");        
    $display("\033[37m    B  BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBi_  /UBBBBBBBBBBBBBBBBBBBBBBBBB. :B:                                                        ");        
    $display("\033[37m   rM .BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB  ..IBBBBBBBBBBBBBBBBQBBBBBBBBBB  B                                                        ");        
    $display("\033[37m   B  BBBBBBBBBdZBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBPBBBBBBBBBBBBEji:..     sBBBBBBBr Br                                                       ");        
    $display("\033[37m  7B 7BBBBBBBr     .:vXQBBBBBBBBBBBBBBBBBBBBBBBBBQqui::..  ...i:i7777vi  BBBBBBr Bi                                                       ");        
    $display("\033[37m  Ki BBBBBBB  rY7vr:i....  .............:.....  ...:rii7vrr7r:..      7B  BBBBB  Bi                                                       ");        
    $display("\033[37m  B. BBBBBB  B:    .::ir77rrYLvvriiiiiiirvvY7rr77ri:..                 bU  iQBB:..rI                                                      ");        
    $display("\033[37m.S: 7BBBBP  B.                                                          vI7.  .:.  B.                                                     ");        
    $display("\033[37mB: ir:.   :B.                                                             :rvsUjUgU.                                                      ");        
    $display("\033[37mrMvrrirJKur                                                                                                                               \033[m");
    report_pass_message; 
end endtask

task report_pass_message; begin
    $display ("----------------------------------------------------------------------------------------------------------------------");
    $display ("                                                  Congratulations!                						             ");
    $display ("                                           You have passed all patterns!          						             ");
    $display ("                                          Total latency is \033[0;35m%7d\033[0m cycles                                ", total_latency); 
    $display ("----------------------------------------------------------------------------------------------------------------------");
end endtask

task fail; begin
	$display ("                                            Oops! There's something WRONG!                                            ");
	$display ("                                                                                                                      ");
end endtask

task REPORT_GOLDEN_ANSWER; begin
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                   Input Matrix                                                       ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("I_MTX[%2d][%1d] = %-4d",i,j, I_MTX[i][j]);
		end
		$display(" ");
	end
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                  After the activation of RAT, Input Matrix be like                                   ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("i_mtx[%2d][%1d] = %-4d",i,j, i_mtx[i][j]);
		end
		$display(" ");
	end
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                 Weight Query Matrix                                                  ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < 8; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("WQ_MTX[%1d][%1d] = %-4d",i,j, WQ_MTX[i][j]);
		end
		$display(" ");
	end
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                              RAT(I_MTX) x WQ_MTX = q_mtx                                             ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("q_mtx[%2d][%1d] = %-4d",i,j, q_mtx[i][j]);
		end
		$display(" ");
	end 
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                  Weight Key Matrix                                                   ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < 8; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("WK_MTX[%1d][%1d] = %-4d",i,j, WK_MTX[i][j]);
		end
		$display(" ");
	end
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                              RAT(I_MTX) x WK_MTX = k_mtx                                             ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("k_mtx[%2d][%1d] = %-4d",i,j, k_mtx[i][j]);
		end
		$display(" ");
	end 
	
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                 Weight Value Matrix                                                  ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < 8; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("WV_MTX[%1d][%1d] = %-4d",i,j, WV_MTX[i][j]);
		end
		$display(" ");
	end
	
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                              RAT(I_MTX) x WV_MTX = v_mtx                                             ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("v_mtx[%2d][%1d] = %-4d",i,j, v_mtx[i][j]);
		end
		$display(" ");
	end 
	
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                           CAT(q_mtx x (k_mtx)^T) = s_mtx                                             ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < length; j=j+1) begin
			$write ("s_mtx[%2d][%2d] = %-8d",i,j, s_mtx[i][j]);
		end
		$display(" ");
	end 
	
	$display ("                                                                                                                      ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	$display ("                                                     O_MTX be like:                                                   ");
	$display ("----------------------------------------------------------------------------------------------------------------------");
	for (i = 0; i < length; i=i+1) begin
		for (j = 0; j < 8; j=j+1) begin
			$write ("O_MTX[%2d][%1d] = %-14d",i,j, O_MTX[i][j]);
		end
		$display(" ");
	end 
	
	
end endtask

endmodule