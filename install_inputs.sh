#! /bin/bash

set -x

mkdir website
cd website

# grab the vmdk file image for all inputs
mkdir INPUTS
wget --no-check-certificate --progress=dot:mega https://mcc.lip6.fr/2023/archives/mcc2023-input.tar.gz
tar xvzf mcc2023-input.tar.gz
../7z e mcc2023-input.vmdk
../ext2rd 0.img ./:INPUTS
# cleanup
rm -f *.vmdk 0.img *.gz 1

# remove strange MacOS specific stuff 'LIBARCHIVE.xattr.com.apple.quarantine'
echo "Patching tgz archives"
set +x
cd INPUTS
for i in *.tgz ;
do
	tar xzf $i
	model=$(echo $i | sed 's/.tgz//g')
#	echo "Treating : $model"
	rm $i
	tar czf $i $model/
	rm -rf $model/
done

# unfortunately, these two models are over 100MB compressed, GH pages does not support such large files without paying.
rm StigmergyCommit-PT-11b.tgz TokenRing-PT-050.tgz

cd ..
set -x

if [ ! -f raw-result-analysis.csv ] 
then
	# grab the raw results file from MCC website
	wget --no-check-certificate --progress=dot:mega https://mcc.lip6.fr/2023/archives/raw-result-analysis.csv.zip
	unzip raw-result-analysis.csv.zip
fi

# create oracle files
mkdir oracle
# all results available
cat raw-result-analysis.csv | grep -v StateSpace | grep -v UpperBound | cut -d ',' -f2,3,16 | sed 's/\s//g' | sort | uniq | ../csv_to_control.pl
# UpperBounds => do not remove whitespace
cat raw-result-analysis.csv | grep UpperBound | cut -d ',' -f2,3,16 | sort | uniq | ../csv_to_control.pl

 
# Patching bad consensus

# Tapaal incorrectly answers 0, should be +inf. Diagnosed by hand, confirmed by Jiri.
# this COL model only has two places, so it is the same error repeated several times.
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-11 0/CryptoMiner-COL-D03N000-UpperBounds-11 +inf/" CryptoMiner-COL-D03N000-UB.out
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-10 0/CryptoMiner-COL-D03N000-UpperBounds-10 +inf/" CryptoMiner-COL-D03N000-UB.out
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-08 0/CryptoMiner-COL-D03N000-UpperBounds-08 +inf/" CryptoMiner-COL-D03N000-UB.out
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-05 0/CryptoMiner-COL-D03N000-UpperBounds-05 +inf/" CryptoMiner-COL-D03N000-UB.out
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-02 0/CryptoMiner-COL-D03N000-UpperBounds-02 +inf/" CryptoMiner-COL-D03N000-UB.out
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-01 0/CryptoMiner-COL-D03N000-UpperBounds-01 +inf/" CryptoMiner-COL-D03N000-UB.out
sed -i -e "s/CryptoMiner-COL-D03N000-UpperBounds-00 0/CryptoMiner-COL-D03N000-UpperBounds-00 +inf/" CryptoMiner-COL-D03N000-UB.out

sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-00 0/CryptoMiner-COL-D05N000-UpperBounds-00 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-02 0/CryptoMiner-COL-D05N000-UpperBounds-02 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-03 0/CryptoMiner-COL-D05N000-UpperBounds-03 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-04 0/CryptoMiner-COL-D05N000-UpperBounds-04 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-05 0/CryptoMiner-COL-D05N000-UpperBounds-05 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-07 0/CryptoMiner-COL-D05N000-UpperBounds-07 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-09 0/CryptoMiner-COL-D05N000-UpperBounds-09 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-10 0/CryptoMiner-COL-D05N000-UpperBounds-10 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-11 0/CryptoMiner-COL-D05N000-UpperBounds-11 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-12 0/CryptoMiner-COL-D05N000-UpperBounds-12 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-13 0/CryptoMiner-COL-D05N000-UpperBounds-13 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-14 0/CryptoMiner-COL-D05N000-UpperBounds-14 +inf/" CryptoMiner-COL-D05N000-UB.out
sed -i -e "s/CryptoMiner-COL-D05N000-UpperBounds-15 0/CryptoMiner-COL-D05N000-UpperBounds-15 +inf/" CryptoMiner-COL-D05N000-UB.out

sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-14 0/CryptoMiner-COL-D10N000-UpperBounds-14 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-12 0/CryptoMiner-COL-D10N000-UpperBounds-12 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-11 0/CryptoMiner-COL-D10N000-UpperBounds-11 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-10 0/CryptoMiner-COL-D10N000-UpperBounds-10 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-06 0/CryptoMiner-COL-D10N000-UpperBounds-06 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-05 0/CryptoMiner-COL-D10N000-UpperBounds-05 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-04 0/CryptoMiner-COL-D10N000-UpperBounds-04 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-03 0/CryptoMiner-COL-D10N000-UpperBounds-03 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-02 0/CryptoMiner-COL-D10N000-UpperBounds-02 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-01 0/CryptoMiner-COL-D10N000-UpperBounds-01 +inf/" CryptoMiner-COL-D10N000-UB.out
sed -i -e "s/CryptoMiner-COL-D10N000-UpperBounds-00 0/CryptoMiner-COL-D10N000-UpperBounds-00 +inf/" CryptoMiner-COL-D10N000-UB.out

# This error is due to ITS-tools driver, so was repeated by the whole +red family
# Confirmed by posing a reachability query AG(p<=2)
sed -i -e "s/PolyORBLF-PT-S02J06T10-UpperBounds-13 9/PolyORBLF-PT-S02J06T10-UpperBounds-13 2/" PolyORBLF-PT-S02J06T10-UB.out

# sed -i -e "s/QuasiLiveness TRUE/QuasiLiveness FALSE/" SieveSingleMsgMbox-PT-d1m06-QL.out
# sed -i -e "s/StigmergyCommit-PT-11a-ReachabilityCardinality-06 TRUE/StigmergyCommit-PT-11a-ReachabilityCardinality-06 FALSE/" StigmergyCommit-PT-11a-RC.out

mv *.out oracle/

#rm -f raw-result-analysis.csv*

cd oracle
tar xzf ../../oracleSS.tar.gz
cd ..
tar czf oracle.tar.gz  oracle/
rm -rf oracle/

tree -H "." > index.html

cd ..
