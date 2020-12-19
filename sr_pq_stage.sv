//
//  Single stage for shift-register PQ
//

module #(parameter kW=8, VW=4) sr_pq_stage (
    input logic clk, rst, push, pop, kprev_lt_ki, knext_lt_ki,
    input logic [KW+VW-1:0] kvi, kvprev, kvnext,
    output logic [KW+VW-1:0] kv,  // key stored in this stage
    output logic kinsert_lt_k
    );

  logic [KW-1:0] k, ki;
  assign k = kv[KW+VW-1:VW];
  assign ki = kvi[KW+VW-1:VW];

  assign k_lt_kinsert = (k < ki);

  always_ff @(posedge clk)
    begin
      if (rst)
        begin
          kv <= { KEYINF, VAL0 };
        end
      else if (pop && push)
        begin
            if (ki_lt_k && kinsert_lt_knext)
                begin  // shift left
                    kv <= kvnext;
                end
            else if (kinsert_lt_k && !kinsert_lt_knext)
                begin  // insert here for simultaneous push, pop
                    kv <= kvi;
                end  // otherwise, this stage doesnt' change
        end
      else if (pop)
        begin
            kb <= kvnext;
        end
      else if (push)
        begin
            if (kinsert_lt_prev && !kinsert_lt_k)
                begin
                    kv <= kvi;
                end
            else if (!kinsert_lt_prev && !kinsert_lt_k)
                begin
                    kv <= kvprev;
                end
        end  // otherwise, this stage doesn't change
    end

endmodule: sr_pq_stage
