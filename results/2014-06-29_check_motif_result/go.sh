#perl bobro2alignment.pl 16131999.closures | perl align2fasta.pl
for i in 16131999 16130248 16130424 16128507 16130807 16128026 16130839 16129025 16129095
do
  cp top_20_inter_12_20_top_10/$i.closures pick_PurR
done

cd pick_PurR
for i in *
do
  perl ../bobro2alignment.pl $i | perl ../align2fasta.pl
done

for i in *.fasta
do
  weblogo -f $i -F png -o $i.png
done

cd ..

for i in 16129950 16128654 16130341 16128924 16130691 16131536 16128731 16129237 16128396 145698279 16131389 16131236 16131333
do
  cp top_20_inter_12_20_top_10/$i.closures pick_CRP
done

cd pick_CRP
for i in *
do
  perl ../bobro2alignment.pl $i | perl ../align2fasta.pl
done

for i in *.fasta
do
  weblogo -f $i -F png -o $i.png
done

cd ..
