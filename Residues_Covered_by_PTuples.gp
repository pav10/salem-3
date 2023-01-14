\\
\\ this is PARI/GP
\\ authors: giacomo cherubini
\\          pavlo yatsyna
\\ updated: 07-11-2022

/* this code is used to verify that, using the collection of seven-tuples we provide in our paper, we cover all even degrees sufficiently large; it is also used to prove that any collection of seven-tuples of the form (2,3,p_3,...,p_7) with p_i<29 will miss some residue class mod 2*3*...*23 and therefore cannot produce all even degrees. */

/* all the 7-tuples (2,3,p_3,...,p_7) with primes up to 23 */
t23 = [[2,3,5,7,11,13,17],[2,3,5,7,11,13,19],[2,3,5,7,11,17,19],[2,3,5,7,13,17,19],[2,3,5,11,13,17,19],[2,3,7,11,13,17,19],[2,3,5,7,11,13,23],[2,3,5,7,11,17,23],[2,3,5,7,11,19,23],[2,3,5,7,13,17,23],[2,3,5,7,13,19,23],[2,3,5,7,17,19,23],[2,3,5,11,13,17,23],[2,3,5,11,13,19,23],[2,3,5,11,17,19,23],[2,3,5,13,17,19,23],[2,3,7,11,13,17,23],[2,3,7,11,13,19,23],[2,3,7,11,17,19,23],[2,3,7,13,17,19,23],[2,3,11,13,17,19,23]];

/* selected 7-tuples with primes up 29 */
t29 = [[2,3,5,7,11,13,17],[2,3,5,7,11,13,19],[2,3,5,7,13,17,19],[2,3,5,11,13,17,19],[2,3,7,11,13,17,19],[2,3,5,7,11,13,23],[2,3,5,7,11,17,23],[2,3,5,7,13,17,23],[2,3,5,7,13,19,23],[2,3,5,11,17,19,23],[2,3,5,13,17,19,23],[2,3,7,13,17,19,23],[2,3,5,7,11,13,29],[2,3,5,7,11,17,29],[2,3,5,7,11,19,29],[2,3,5,7,11,23,29],[2,3,5,7,13,17,29],[2,3,5,7,13,19,29],[2,3,5,7,13,23,29],[2,3,5,7,17,19,29],[2,3,5,7,17,23,29],[2,3,5,7,19,23,29],[2,3,5,11,13,17,29],[2,3,5,11,13,19,29],[2,3,5,11,13,23,29],[2,3,5,11,17,19,29],[2,3,5,11,19,23,29],[2,3,5,13,17,19,29],[2,3,5,13,17,23,29],[2,3,5,13,19,23,29],[2,3,5,17,19,23,29],[2,3,7,11,13,17,29],[2,3,7,11,13,19,29],[2,3,7,11,13,23,29],[2,3,7,11,17,19,29],[2,3,7,11,17,23,29],[2,3,7,13,17,23,29],[2,3,7,13,19,23,29]];\\38 tuples suffice, the others were: [2,3,11,13,17,19,29],[2,3,11,13,17,23,29],[2,3,11,17,19,23,29],[2,3,13,17,19,23,29]];

/* A shorter list of 21 7-tuples should suffice */
t29short = [[2, 3, 5, 7, 11, 13, 17], [2, 3, 5, 7, 11, 13, 19], [2, 3, 5, 7, 13, 17, 19], [2, 3, 5, 11, 13, 17, 19], [2, 3, 7, 11, 13, 17, 19], [2, 3, 5, 7, 11, 13, 23], [2, 3, 5, 7, 11, 17, 23], [2, 3, 5, 7, 13, 19, 23], [2, 3, 5, 11, 17, 19, 23], [2, 3, 5, 13, 17, 19, 23], [2, 3, 7, 13, 17, 19, 23], [2, 3, 5, 7, 11, 13, 29], [2, 3, 5, 7, 11, 17, 29], [2, 3, 5, 7, 13, 17, 29], [2, 3, 5, 7, 13, 19, 29], [2, 3, 5, 7, 13, 23, 29], [2, 3, 5, 7, 17, 19, 29], [2, 3, 5, 11, 13, 23, 29], [2, 3, 5, 11, 19, 23, 29], [2, 3, 7, 11, 13, 19, 29], [2, 3, 11, 17, 19, 23, 29]];



MinimalityOfGivenCollection(T=t29short)=
   {
   \\this function verifies that the collection T
   \\is minimal in the sense that removing any of
   \\its elements will lead to missing at least
   \\one residue class modulo 2*3*...*29.
   my(t,n,R);
   n = length(T);
   i = #T;\\start from the bottom. Requires 1GB of RAM
          \\for each tuple except i=1,
          \\when 2GB of RAM are needed.
   while(i>=1,
      t = [];
      for(j=1,n,
         if(j!=i,
            t = concat(t,[T[j]]);
            );
         );
      print("index i="i", "T[i]" omitted. Checking residues modulo 2*3*...*29:");
      R = CoveringEvenResidues(t);
      print(#R" residues missed, the first being = "R[1]);
      i--;
      );
   return;
   }



CoveringEvenResidues(tuples)=
   {
   my(L,Lj,Laux,Lpart,q,qj,Q,r,u,m);
   L = CreateBadResidues(tuples[1]);
   q = prod(i=1,length(tuples[1]),tuples[1][i]);
   for(j=2,length(tuples),
      print1(j",");
      Lj = CreateBadResidues(tuples[j]);
      qj = prod(i=1,length(tuples[j]),tuples[j][i]);
      Q = lcm(q,qj);
      L = extend(L,q,Q);
      r = Q/qj;
      u = vector(length(Lj),i,qj);
      Laux = [];
      m = 1;
      for(i=0,r-1,
         Lpart = List();
         while(m<=length(L)&&L[m]>=i*qj&&L[m]<(i+1)*qj,
            listput(Lpart,L[m]);
            m++;
            );
         Laux = concat(Laux,setintersect(Set(Lpart),Lj+i*u));
         );
      L = Laux;
      q = Q;
      if(Laux==[],
         print("j=",j);
         j = length(tuples)+1;
         );
      );
   return(L);\\returns the residues that are not represented by any of the given tuples
   }



CreateBadResidues(p)=
   {
   my(s,q,J);
   s = sum(i=1,length(p),p[i]);
   q = prod(i=1,length(p),p[i]);
   J = vector(q,i,if(i%2==1&&gcd(i,q)>1,(i+s-5)%q,0));\\notice the -5
   J = Set(J);
   /* now, the zero residue could be redundant */
   if(gcd(s-5,q)==1,
      J = vector(length(J)-1,i,J[i+1]);\\zero is always present as the first element
      );
   return(J);
   }


extend(v,q,Q)=
   {
   my(r,w,u);
   r = Q/q;
   w = [];
   u = vector(length(v),i,q);
   for(j=0,r-1,
      w = concat(w,v+j*u);
      );
   return(w);
   }



SmallResidues(tuples)=
   {
   my(u,s,L,n,G);
   u = vector(length(tuples[1]),i,1);
   s = vecmax(vector(length(tuples),i,tuples[i]*u~));
   L = vector(s/2,i,2*i);
   for(i=1,length(tuples),
      G = [];
      s = tuples[i]*u~;
      q = prod(j=1,length(tuples[i]),tuples[i][j]);
      for(j=1,length(L),
         n = L[j]-s+5;
         if(n>5&&gcd(n,q)==1,
            G = concat(G,L[j]);
            );
         );
      L = setminus(L,G);
      );
   return(L);
   }


