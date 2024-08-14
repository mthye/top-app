# Standard 2: Data

dataTypes <- c(
  "Arterial Spin Labelling (ASL) - non-clinical sample",
  "Arterial Spin Labelling (ASL) - clinical sample",
  "Assessment instruments - non-clinical sample",
  "Assessment instruments - clinical sample",
  "Audio data - non-clinical sample",
  "Audio data - clinical sample",
  "Behaviour (e.g. reaction times, accuracy etc.) - clinical sample",
  "Behaviour (e.g. reaction times, accuracy etc.) - non-clinical sample",
  "Clinical diagnostic data",
  "Diffusion MRI (dMRI) - non-clinical sample",
  "Diffusion MRI (dMRI) - clinical sample",
  "Ecological Momentary Assessment (EMA) - non-clinical sample",
  "Ecological Momentary Assessment (EMA) - clinical sample",
  "Electroencephalography (EEG) - non-clinical sample",
  "Electroencephalography (EEG) - clinical sample",
  "Eye-tracking - non-clinical sample",
  "Eye-tracking - clinical sample",
  "Functional MRI (fMRI) - non-clinical sample",
  "Functional MRI (fMRI) - clinical sample",
  "Functional Near-infrared Spectroscopy (fNIRS) - non-clinical sample",
  "Functional Near-infrared Spectroscopy (fNIRS) - clinical sample",
  "Gait/walking - non-clinical sample",
  "Gait/walking - clinical sample",
  "Galvanic skin response (GSR) - non-clinical sample",
  "Galvanic skin response (GSR) - clinical sample",
  "Histological samples - non-clinical sample",
  "Histological samples - clinical sample",
  "Human tissue - non-clinical sample",
  "Human tissue - clinical sample",
  "Interview transcripts - non-clinical sample",
  "Interview transcripts - clinical sample",
  "Kinematic data - non-clinical sample",
  "Kinematic data - clinical sample",
  "Magnetic Resonance Spectroscopy (MRS) - non-clinical sample",
  "Magnetic Resonance Spectroscopy (MRS) - clinical sample",
  "Magnetoencephalography (MEG) - non-clinical sample",
  "Magnetoencephalography (MEG) - clinical sample",
  "Meta-analytic data extracted from prior literature",
  "Pupillometry - non-clinical sample",
  "Pupillometry - clinical sample",
  "Questionnaires - non-clinical sample",
  "Questionnaires - clinical sample",
  "Simulated data (modelling) - non-clinical sample",
  "Simulated data (modelling) - clinical sample",
  "Structural MRI (sMRI) - non-clinical sample",
  "Structural MRI (sMRI) - clinical sample",
  "Video data - non-clinical sample",
  "Video data - clinical sample"
)



dataReason <- c(
  "N/A - ALL data are publicly available",
  "Legal barrier only",
  "Ethical barrier only",
  "Technical barrier only",
  "Legal and ethical barrier",
  "Legal and technical barrier",
  "Ethical and technical barrier",
  "Legal, ethical and technical barrier",
  "Other barrier (contact Editor)",
  "Author preference"
)

dataPublic <- c(
  "Data in repository (URL required)", "Data in Supplementary Information",
  "Data is contained in the paper", "N/A - NO data are publicly available"
)

dataRestricted <- c(
  "Readers can never access the 'restricted' data",
  "Request to corresponding author",
  "Request to ethics committee(s)",
  "Request or apply to external authority"
)

dataCondition <- c(
  "Readers can never access the 'restricted' data",
  "Shared unconditionally upon request to author(s)",
  "Formal data sharing agreement",
  "Approval by ethics committee(s)",
  "Process managed by an external independent curator",
  "Data sharing agreement AND approval by ethics committee(s)"
)
# Make all possible combinations here and remove completion of formal.
# Add ethics approval.

dataHelper1 <- c(
  "<b> Raw data: </b>", "All individual data (anonymised as required) that are sufficient to reproduce 
  the LOWEST-level data processing procedures.",
  "<b> Processed data: </b>", "Raw data that have been pre-processed and summarised for higher-level analyses (anonymised as required).",
  "<i> Note. </i>", "If the raw/processed distinction does not apply to your selected data category, please provide the same 
  answers for both and let the Editor know about this when you submit the TOP report.",
  "<b> Table editing: </b>", "You can paste URLs directly into the table cells.
                Please do not attempt to change any text as it appears- the only text input that may be required is a URL.",
  "<b> Legal barrier: </b>", " IP or commercial barrier that the authors do not have legal permission to circumvent.",
  "<b> Ethical barrier: </b>", "Archiving of anonymised data is ethically permitted but the data cannot be fully anonymised,
                 or public archiving of anonymised data is not permitted by the ethics committee(s)",
  "<b> Technical barrier: </b>", "Technical reasons such as a size limit for shared data will not be considered valid for meeting
                  Level 2 for this standard. Please contact the Editor for further guidance regarding such issues.",
  "<b> No formal barrier: </b>", "If you choose the option 'We prefer not to make data publicly available' please be aware that
                  the manuscript will be rejected for not meeting Level 2 criteria for this standard.",
  "<b> Other barrier: </b>", "Other reasons for not making the data publicly available will need to be disclosed with the Editor."
)


# Standard 3: Analysis code

codeTypes <- c(
  "AFNI code",
  "C++ code",
  "Excel macro code",
  "FreeSurfer code",
  "FSL code",
  "Google Apps Script code",
  "GraphPad Prism syntax",
  "JAGS code",
  "Jamovi syntax (R)",
  "JavaScript code",
  "JMP code",
  "Matlab code",
  "Octave code",
  "Python code",
  "R or R Markdown code",
  "S or S-PLUS code",
  "SAS code",
  "SPM code",
  "SPSS syntax",
  "STATA code"
)

codeHelper1 <- c(
  "<b> Raw data: </b>", "ADD HERE",
  "test")

codeReason <- c(
  "N/A - ALL code is publicly available",
  "Legal barrier only",
  "Ethical barrier only",
  "Technical barrier only",
  "Legal and ethical barrier",
  "Legal and technical barrier",
  "Ethical and technical barrier",
  "Legal, ethical and technical barrier",
  "Other barrier (contact Editor)",
  "Author preference"
)

codePublic <- c(
  "Code in repository (URL required)", "Code in Supplementary Information",
  "Code is contained in the paper", "N/A - NO code is publicly available"
)

codeRestricted <- c(
  "Readers can never access the 'restricted' code",
  "Request to corresponding author",
  "Request to ethics committee(s)",
  "Request or apply to external authority"
)

codeCondition <- c(
  "Readers can never access the 'restricted' code",
  "Shared unconditionally upon request to author(s)",
  "Formal code sharing agreement",
  "Approval by ethics committee(s)",
  "Process managed by an external independent curator"
)

# Standard 4: Research Materials

matsTypes <- c(
  "Code or software deployed via computer",
  "Code within hardware other than a computer",
  "Code for an app/software using mobile phone or tablet",
  "Survey(s) via computer or other electronic device",
  "Survey(s) in paper form", 
  "Semi-structured interview questions via computer",
  "Semi-structured interview questions in paper form",
  "Psychometric instrument(s) via computer or other electronic device",
  "Psychometric instrument(s) in paper form",
  "Clinical assessment tool(s) via computer or other electronic device",
  "Clinical assessment tool(s) in paper form",
  "Non-clinical task(s) or measurement(s) in paper form",
  "Visual or auditory stimuli (e.g., still images, videos, sounds)",
  "Observation schedule(s)",
  "Instructions to or for participants (e.g., script, protocol, visual or audio guide)",
  "Procedural manual (e.g., protocol or coding guide for content analysis)"
)

matsHelper1 <- c(
  "<b> Raw data: </b>", "ADD HERE",
  "test")

matsReason <- c(
  "N/A - ALL materials are publicly available",
  "Legal barrier only",
  "Ethical barrier only",
  "Technical barrier only",
  "Legal and ethical barrier",
  "Legal and technical barrier",
  "Ethical and technical barrier",
  "Legal, ethical and technical barrier",
  "Other barrier (contact Editor)",
  "Author preference"
)

matsPublic <- c(
  "Materials in repository (URL required)", "Materials in Supplementary Information",
  "Materials are contained in the paper", "N/A - NO materials are publicly available"
)

matsRestricted <- c(
  "Readers can never access the 'restricted' materials",
  "Request to corresponding author",
  "Request to ethics committee(s)",
  "Request or apply to external authority"
)

matsCondition <- c(
  "Readers can never access the 'restricted' materials",
  "Shared unconditionally upon request to author(s)",
  "Approval by ethics committee(s)",
  "Process managed by an external independent curator"
)
