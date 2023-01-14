\\
\\ this is PARI/GP
\\ authors : giacomo cherubini
\\           pavlo yatsyna
\\ updated : 21-09-2022

/* this code is used to verify that the construction with the quadruples of primes and the auxiliary deg-8 polynomials produces Salem polynomials of the desired degrees: 54,56,60,62,64,66,68,70,74,80. */

/* construct the auxiliary polynomial as described in our paper */
Special(p)=\\p is a list of 4 primes
   {
   local(f);
   f = polcyclo(30)/polcyclo(1)/polcyclo(2)/polcyclo(3)/polcyclo(5);
   f+ = (x^(p[1]+p[2])-1)/(x^p[1]-1)/(x^p[2]-1);
   f+ = (x^(p[3]+p[4])-1)/(x^p[3]-1)/(x^p[4]-1);
   return((x^2-1)*denominator(f)-x*numerator(f));
   }

Candidates=[[7,11,13,17],[7,11,13,19],[7,11,13,23],[7,13,17,19],[7,11,17,23],[7,11,19,23],[7,13,19,23],[7,11,17,29],[7,13,19,29],[7,11,19,37]];


/*
for a list of quadruples C, construct the polynomial
described in our paper and test it is irreducible (output=1)
*/
TestSpecial(C=Candidates)=\\C is a list of quadruples of primes
   {
   for(i=1,length(C),
      print1(C[i]": ");
      print1("irreducible = "polisirreducible(Special(C[i])));
      print(", degree = "poldegree(Special(C[i])));
      );
   return;
   }

