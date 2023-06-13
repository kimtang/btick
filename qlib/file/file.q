
d) module
 file
 Library for working with the file
 q).import.module`file

.file.head0:{[inc;file;nline]
 result:"\n"vs{[nline;file;inc;stream]n:sum "\n"= stream;if[n>=nline;:stream]; stream,"c"$read1 (file;count stream;inc) }[nline;file;inc] over "c"$read1 (file;0;inc);
 nline:min nline,count result;
 :nline # result
 }

.file.head:{[file;nline] .file.head0[prd 14#2;file;nline]}

d) function
 file
 .file.head
 return the head of a file
 q) .file.head[`:file.csv;2] / show the first two lines of a file
 q) .file.head[`:file.csv;100]