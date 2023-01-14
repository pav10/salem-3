\\
\\ this is PARI/GP
\\ authors : giacomo cherubini
\\           pavlo yatsyna
\\ updated : 21-09-2022

/* this code is used to verify that all the seven-tuples we provide in our paper produce families of irreducible polynomials. */

/*
function PQ(plist): given a list of primes plist,
returns the two polynomials P and Q as described in our paper
*/
PQ(plist) = 
   {
   my(l,S);
   l = length(plist);
   S = (x^plist[l]*y-1)/((x^plist[l]-1)*(y-1));
   for(i=1,(l-1)/2,
      S+ = (x^(plist[2*i-1]+plist[2*i])-1)/((x^plist[2*i-1]-1)*(x^plist[2*i]-1));
      );
   return([denominator(S),numerator(S)]);\\returns [P,Q]
   }


/*
function Curves(plist): given a list of primes,
returns the four curves corresponding to x,-x,x^2,-x^2
*/
Curves(plist)=
   {
   my(P,Q);
   [P,Q] = PQ(plist);
   my(C1,C2,C3,C4);
   C1 = (x^2-1)*P-x*Q;
   C2 = subst(subst(C1,x,-x),y,-y);
   C3 = subst(subst(C1,x,x^2),y,y^2);
   C4 = subst(subst(C1,x,-x^2),y,-y^2);
   return([C1,C2,C3,C4]);
   }


/*
function Resultants(plist): given a list of primes,
returns the resultants between all possible pairs of curves created above.
*/
Resultants(plist)=
   {
   my(C,R,t);
   C = Curves(plist);
   R = vector(6);
   t = 1;
   for(j=2,4,
         R[t] = polresultant(C[1],C[j],x);
         t++;
         \\print1("!");
         R[t] = polresultant(C[1],C[j],y);
         t++;
         \\print1("!");
      );
   \\R = concat(apply(z->polresultant(C[1],z,x),C[2..4]),apply(z->polresultant(C[1],z,y),C[2..4]));\\same output up to reshuflling the components
   return(R);
   }


/* given a polynomial f, returns (the index of) its irreducible cyclotomic factors */
Cyclotomic_factors(f)=
   {
   return(Set(apply(poliscyclo,factor(f)[,1])));
   }




/*
Test0: given a polynomial f and a list of primes,
returns what case we are in.
*/
Test0(f,plist)=
   {
   \\print("! inside Test0, checking curve");
   local(w,S);
   w = Cyclotomic_factors(f);
   if(polisirreducible(f),
      return("Case I")
      ,
      \\print("w:"poldegree(w));
      S = setminus(w,concat([0,1],plist));
      if(!#S,
         return("Case II")
         ,
         if(S==[12],
            return("Case III")
            ,
            if(S==[20],
               return("Case IV")
               ,
               return([S,"If [4] & the next is Case III or IV, ok, else fail."])
               );
            );
         );
      );           
   }




Test(plist)=
   {
   my(R);
   R = Resultants(plist);
   return(vector(length(R),i,Test0(R[i],plist)));
   }


t29 = [[2,3,5,7,11,13,17],[2,3,5,7,11,13,19],[2,3,5,7,13,17,19],[2,3,5,11,13,17,19],[2,3,7,11,13,17,19],[2,3,5,7,11,13,23],[2,3,5,7,11,17,23],[2,3,5,7,13,17,23],[2,3,5,7,13,19,23],[2,3,5,11,17,19,23],[2,3,5,13,17,19,23],[2,3,7,13,17,19,23],[2,3,5,7,11,13,29],[2,3,5,7,11,17,29],[2,3,5,7,11,19,29],[2,3,5,7,11,23,29],[2,3,5,7,13,17,29],[2,3,5,7,13,19,29],[2,3,5,7,13,23,29],[2,3,5,7,17,19,29],[2,3,5,7,17,23,29],[2,3,5,7,19,23,29],[2,3,5,11,13,17,29],[2,3,5,11,13,19,29],[2,3,5,11,13,23,29],[2,3,5,11,17,19,29],[2,3,5,11,19,23,29],[2,3,5,13,17,19,29],[2,3,5,13,17,23,29],[2,3,5,13,19,23,29],[2,3,5,17,19,23,29],[2,3,7,11,13,17,29],[2,3,7,11,13,19,29],[2,3,7,11,13,23,29],[2,3,7,11,17,19,29],[2,3,7,11,17,23,29],[2,3,7,13,17,23,29],[2,3,7,13,19,23,29]];\\38 tuples suffice, the others were: [2,3,11,13,17,19,29],[2,3,11,13,17,23,29],[2,3,11,17,19,23,29],[2,3,13,17,19,23,29]];


LaunchTest(t=tuples)=
   {
   my(plist);
   for(i=1,length(t),
      plist = t[i];
      print(plist": "Test(plist));
      );
   return;
   }





