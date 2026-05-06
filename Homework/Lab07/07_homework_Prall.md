# Homework 7: Filtering
## Jack Prall

## Justifying my personal setting choices
- minQ was set to 40. This filters low quality reads, but the value reflects standard practices (it's from the tutorial).
- mac was set to 3 because Linck & Battey, 2019 suggested this to be in the optimal range for analyses
- maf was set to 0.167 because it is 3 out of 18, which should match the mac value, and I wasn't super confident that on using any other settings
- max-missing-count was set to 2 because I have 9 samples, and anything over that would represent over 25% of the data is missing
- min-meanDP was set to 50 because that seemed to be a good threshold, based on the results from Lab 5
    - This was reset to 10 because I didn't get any variants out
    - This was eventually removed entirely because it filtered all variation

## Summary Statistic
I calculated the pi-value for all unfiltered SNPs in my dataset (n = 44). The full table is reported below.
- Average Pi = 0.4529
- Interpretation: For any two SNPs from all unfiltered reads from all samples, sites will show variation 45.3% of the time. Given the filtering of rare alleles, this value seems sensible as we are only left with 44 of the original 468 SNPs. As the remaining SNPs represent less than 10% of the total SNPs, the higher degree of genetic variation between samples reflects these fewer, but more common variable sites.

## Full output of Pi values

'''
CHROM	POS	PI
HBAA_Sicalis_luteiventris	285	0.525
HBAA_Sicalis_luteiventris	362	0.458333
HBAA_Sicalis_luteiventris	556	0.525
HBAA_Sicalis_luteiventris	863	0.325
HBAD_Sicalis_luteiventris	126	0.525
HBAD_Sicalis_luteiventris	483	0.525
HBAD_Sicalis_luteiventris	539	0.5
HBB2_Sicalis_luteiventris	114	0.525
HBB2_Sicalis_luteiventris	219	0.4
HBB2_Sicalis_luteiventris	488	0.325
HBB2_Sicalis_luteiventris	623	0.5
HBB2_Sicalis_luteiventris	726	0.4
HBB2_Sicalis_luteiventris	864	0.533333
HBB2_Sicalis_luteiventris	1017	0.525
HBB2_Sicalis_luteiventris	1301	0.325
HBB2_Sicalis_luteiventris	1386	0.525
HBB2_Sicalis_luteiventris	1943	0.4
HBB2_Sicalis_luteiventris	2023	0.5
HBB2_Sicalis_luteiventris	2092	0.325
HBB2_Sicalis_luteiventris	2203	0.325
HBB_Sicalis_luteiventris	96	0.4
HBB_Sicalis_luteiventris	163	0.5
HBB_Sicalis_luteiventris	450	0.458333
HBB_Sicalis_luteiventris	506	0.325
HBB_Sicalis_luteiventris	706	0.325
HBB_Sicalis_luteiventris	905	0.5
HBE_Sicalis_luteiventris	443	0.325
HBE_Sicalis_luteiventris	720	0.458333
HBE_Sicalis_luteiventris	941	0.4
HBE_Sicalis_luteiventris	1068	0.533333
HBE_Sicalis_luteiventris	1296	0.525
HBPI_Sicalis_luteiventris	201	0.533333
HBPI_Sicalis_luteiventris	393	0.458333
HBPI_Sicalis_luteiventris	771	0.458333
HBPI_Sicalis_luteiventris	896	0.325
HBPI_Sicalis_luteiventris	1021	0.525
HBPI_Sicalis_luteiventris	1474	0.525
HBPI_Sicalis_luteiventris	1569	0.458333
HBPI_Sicalis_luteiventris	1705	0.5
HBPI_Sicalis_luteiventris	1886	0.458333
HBRH_Sicalis_luteiventris	452	0.325
HBRH_Sicalis_luteiventris	787	0.4
HBRH_Sicalis_luteiventris	855	0.525
HBRH_Sicalis_luteiventris	944	0.4
'''
