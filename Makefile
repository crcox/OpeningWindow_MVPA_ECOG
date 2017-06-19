export MCC=$(MATLABDIR)/bin/mcc
export MEX=$(MATLABDIR)/bin/mex
export MFLAGS=-m -R -singleCompThread -R -nodisplay -R -nojvm
TOP := $(shell pwd)
SRCTAR=source_code.tar.gz
SRC=src
DEP=dependencies
DATA=data
GLMNET=$(DEP)/glmnet
INCL= -N -I $(SRC) -I $(GLMNET)
.PHONEY: all clean-all clean-postbuild glmnet sdist

all: setup glmnet OpeningWindow_MVPA_ECOG OpeningWindow_AccuracyProfile_MVPA_ECOG clean-postbuild

setup:
	tar xzvf $(SRCTAR)

glmnet: $(GLMNET)/glmnetMex.mexa64
$(GLMNET)/glmnetMex.mexa64: $(GLMNET)/glmnetMex.F $(GLMNET)/GLMnet.f
	$(MEX) -fortran -outdir $(GLMNET) $^

OpeningWindow_MVPA_ECOG: $(SRC)/OpeningWindow_MVPA_ECOG.m
	$(MCC) -v $(MFLAGS) $(INCL) -a $(DATA) -o $@ $<

OpeningWindow_AccuracyProfile_MVPA_ECOG: $(SRC)/OpeningWindow_AccuracyProfile_MVPA_ECOG.m
	$(MCC) -v $(MFLAGS) $(INCL) -a $(DATA) -o $@ $<

clean-postbuild:
	-rm *.dmr
	-rm mccExcludedFiles.log
	-rm readme.txt

sdist:
	tar czhf $(SRCTAR) src dependencies data

clean-all:
	-rm OpeningWindow_MVPA_ECOG
	-rm OpeningWindow_AccuracyProfile_MVPA_ECOG
	-rm $(DEP)
	-rm $(DATA)
	-rm $(SRC)
	-rm requiredMCRProducts.txt
	-rm build-csf-openingwindow_rsa_ecog.sh.e*
	-rm build-csf-openingwindow_rsa_ecog.sh.o*
