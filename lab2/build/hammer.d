HAMMER_EXEC ?= /home/cc/eecs151/fa25/class/eecs151-acf/venv_151/bin/hammer-vlsi
HAMMER_DEPENDENCIES ?= /home/tmp/eecs151-acf/asic-labs-fa25/lab2/sky130.yml /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sram_generator-output.json /home/tmp/eecs151-acf/asic-labs-fa25/lab2/design.yml /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml /home/tmp/eecs151-acf/asic-labs-fa25/lab2/src/fir.v /home/tmp/eecs151-acf/asic-labs-fa25/lab2/src/EECS151.v /home/tmp/eecs151-acf/asic-labs-fa25/lab2/src/addertree.v


####################################################################################
## Global steps
####################################################################################
.PHONY: pcb
pcb: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/pcb-rundir/pcb-output-full.json

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/pcb-rundir/pcb-output-full.json: $(HAMMER_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/sky130.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sram_generator-output.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/design.yml --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build pcb


####################################################################################
## Steps for fir
####################################################################################
.PHONY: sim-rtl syn syn-to-sim sim-syn syn-to-par par par-to-sim sim-par sim-par-to-power par-to-power power-par power-rtl sim-rtl-to-power sim-syn-to-power syn-to-power power-syn par-to-drc drc par-to-lvs lvs syn-to-formal formal-syn par-to-formal formal-par syn-to-timing timing-syn par-to-timing timing-par

sim-rtl          : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir/sim-output-full.json
syn              : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json

syn-to-sim       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json
sim-syn          : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir/sim-output-full.json

syn-to-par       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json
par              : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json

par-to-sim       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json
sim-par          : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir/sim-output-full.json

sim-par-to-power : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json
par-to-power     : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json
power-par        : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-rundir/power-output-full.json

sim-rtl-to-power : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json
power-rtl        : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-rtl-rundir/power-output-full.json

sim-syn-to-power : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json
syn-to-power     : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json
power-syn        : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-rundir/power-output-full.json

par-to-drc       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json
drc              : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-rundir/drc-output-full.json

par-to-lvs       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json
lvs              : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-rundir/lvs-output-full.json

syn-to-formal    : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json
formal-syn       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-rundir/formal-output-full.json

par-to-formal    : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-input.json
formal-par       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-rundir/formal-output-full.json

syn-to-timing    : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json
timing-syn       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-rundir/timing-output-full.json

par-to-timing    : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-input.json
timing-par       : /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-rundir/timing-output-full.json



/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir/sim-output-full.json: $(HAMMER_DEPENDENCIES) $(HAMMER_SIM_RTL_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/sky130.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sram_generator-output.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/design.yml $(HAMMER_EXTRA_ARGS) --sim_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir/sim-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim-to-power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-rtl-rundir/power-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json $(HAMMER_POWER_RTL_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-rtl-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json: $(HAMMER_DEPENDENCIES) $(HAMMER_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/sky130.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sram_generator-output.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/design.yml $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-sim

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir/sim-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json $(HAMMER_SIM_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json $(HAMMER_EXTRA_ARGS) --sim_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir/sim-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim-to-power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-rundir/power-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json $(HAMMER_POWER_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-par

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json $(HAMMER_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-sim

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir/sim-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json $(HAMMER_SIM_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json $(HAMMER_EXTRA_ARGS) --sim_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir/sim-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim-to-power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-rundir/power-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json $(HAMMER_POWER_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build power

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-drc

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-rundir/drc-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json $(HAMMER_DRC_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build drc

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-lvs

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-rundir/lvs-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json $(HAMMER_LVS_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build lvs

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-formal

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-rundir/formal-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json $(HAMMER_FORMAL_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build formal

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-formal

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-rundir/formal-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json $(HAMMER_FORMAL_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build formal

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-timing

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-rundir/timing-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json $(HAMMER_TIMING_SYN_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build timing

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-input.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-timing

/home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-rundir/timing-output-full.json: /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json $(HAMMER_TIMING_PAR_DEPENDENCIES)
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build timing

# Redo steps
# These intentionally break the dependency graph, but allow the flexibility to rerun a step after changing a config.
# Hammer doesn't know what settings impact synthesis only, e.g., so these are for power-users who "know better."
# The HAMMER_EXTRA_ARGS variable allows patching in of new configurations with -p or using --to_step or --from_step, for example.
.PHONY: redo-sim-rtl redo-sim-rtl-to-power redo-syn redo-syn-to-sim redo-syn-to-power redo-sim-syn redo-sim-syn-to-power redo-syn-to-par redo-par redo-par-to-sim redo-sim-par redo-sim-par-to-power redo-par-to-power redo-power-par redo-par-to-drc redo-drc redo-par-to-lvs redo-lvs redo-syn-to-formal redo-formal-syn redo-par-to-formal redo-formal-par redo-syn-to-timing redo-timing-syn redo-par-to-timing redo-timing-par

redo-sim-rtl:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/sky130.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sram_generator-output.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/design.yml $(HAMMER_EXTRA_ARGS) --sim_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim

redo-sim-rtl-to-power:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-rtl-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim-to-power

redo-power-rtl:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-rtl-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-rtl-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build power

redo-syn:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/sky130.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sram_generator-output.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/design.yml $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn

redo-syn-to-sim:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-sim

redo-syn-to-power:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-power

redo-sim-syn:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-input.json $(HAMMER_EXTRA_ARGS) --sim_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim

redo-sim-syn-to-power:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-syn-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim-to-power

redo-syn-to-par:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-par

redo-power-syn:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-syn-input.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build power

redo-par:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par

redo-par-to-sim:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-sim

redo-sim-par:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-input.json $(HAMMER_EXTRA_ARGS) --sim_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim

redo-sim-par-to-power:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/sim-par-rundir/sim-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build sim-to-power

redo-par-to-power:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-power

redo-power-par:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-sim-par-input.json -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-input.json $(HAMMER_EXTRA_ARGS) --power_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/power-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build power

redo-par-to-drc:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-drc

redo-drc:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/drc-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build drc

redo-par-to-lvs:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-lvs

redo-lvs:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/lvs-input.json $(HAMMER_EXTRA_ARGS) --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build lvs

redo-syn-to-formal:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-formal

redo-formal-syn:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build formal

redo-par-to-formal:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-formal

redo-formal-par:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-input.json $(HAMMER_EXTRA_ARGS) --formal_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/formal-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build formal

redo-syn-to-timing:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/syn-rundir/syn-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build syn-to-timing

redo-timing-syn:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-syn-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build timing

redo-par-to-timing:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/par-rundir/par-output-full.json $(HAMMER_EXTRA_ARGS) -o /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-input.json --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build par-to-timing

redo-timing-par:
	$(HAMMER_EXEC) -e /home/tmp/eecs151-acf/asic-labs-fa25/lab2/inst-env.yml -p /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-input.json $(HAMMER_EXTRA_ARGS) --timing_rundir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build/timing-par-rundir --obj_dir /home/tmp/eecs151-acf/asic-labs-fa25/lab2/build timing

