output_name = force_regs.random.ucli

$(output_name): force_regs.ucli
	awk 'BEGIN{srand();}{if ($$1 != "") { print $$1,$$2,$$3,int(rand()*2)}}' $< > $@

foo.txt: $(output_name)
	echo "I am a useless file"


clean:
	rm -f $(output_name)
