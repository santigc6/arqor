FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp
.PHONY: clean all

all: pi_serie pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7

pi_serie: pi_serie.c
			gcc $(FLAGS) -o $@ $^
pi_par1: pi_par1.c
		gcc $(FLAGS) -o $@ $^
pi_par2: pi_par2.c
		gcc $(FLAGS) -o $@ $^
pi_par3: pi_par3.c
		gcc $(FLAGS) -o $@ $^
pi_par4: pi_par4.c
		gcc $(FLAGS) -o $@ $^
pi_par5: pi_par5.c
		gcc $(FLAGS) -o $@ $^
pi_par6: pi_par6.c
		gcc $(FLAGS) -o $@ $^
pi_par7: pi_par7.c
		gcc $(FLAGS) -o $@ $^


clean:
	 rm -f *.o *~ pi_serie pi_par1 pi_par2 pi_par3 pi_par4 pi_par5 pi_par6 pi_par7
