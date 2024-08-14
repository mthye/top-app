fluidPage(
  accordion(
    id = "faq",
    accordionItem(
      title = HTML("<h5 style='color: white; '><b>Frequently Asked Questions</b></h5>"),
      
      status = "primary",
      collapsed = FALSE,
      HTML("
      <ol>
      <h5 style>
      <li style='color: #cfabed; font-weight: bold'>At what level should data be made accessible to satisfy data transparency requirements?</li>
      
      For empirical studies using original data, all anonymised raw and processed data at the individual level (i.e., per participant) that are sufficient to 
      reproduce the data analysis reported in the paper should be publicly archived either in a trusted digital repository or in Supplementary Materials (SI).
            <br></br>
            
      <li style='color: #cfabed; font-weight: bold'>Can the transparency criteria be met if data, analysis code and/or research materials cannot be shared?</li>
      <b>Yes</b>, as long as you provide a valid reason for the lack of public availability and declare what (if any) the conditions for access are.
      In this app we provide you with a fixed list of reasons and present warnings when your responses are not compatible with the transparency guidelines.
            <br></br>

      <li style='color: #cfabed; font-weight: bold'>Is there a specific format for how data should be made available?</li>
      <b>No</b>, as long as the data are publicly accessible in a well-organised manner and preserved for long term access within a trusted digital repository. 
      However, to provide basic guidance notes on reuse, a README file is required that defines every file in the repository and every variable name/abbreviation in the files.
            <br></br>
      
      <li style='color: #cfabed; font-weight: bold'>What should I share if the current study reuses data available form public repositories?</li>
      For studies using secondary data, the program code, scripts for statistical packages, and other documentation must be provided to allow an informed researcher 
      to precisely reproduce all published results.
            <br></br>
      
      <li style='color: #cfabed; font-weight: bold'>What details must be included when archiving analytic code?</li>
      Any analytic files (including custom code) or scripts for statistical packages that are sufficient to allow an informed researcher to precisely reproduce all published results must be made publicly available. 
      Moreover, to provide basic guidance notes on reuse, a README file is required that defines every code file and every variable name/abbreviation in the files.
            <br></br>
      
      <li style='color: #cfabed; font-weight: bold'>Should I archive materials such as questionnaires, surveys, interview questions, or neuropsychological batteries?</li>
      <b>Yes</b>, if these materials can be legally publicly archived, then please add them as supplementary information or include them in a freely accessible repository (e.g., OSF). 
      If any are already freely publicly available then include the URL in these sections to those materials. 
      If any cannot be archived, in this app we provide you with a fixed list of reasons and present warnings when your responses are not compatible with the Research Materials Transparency guidelines.
            <br></br>
            
      <li style='color: #cfabed; font-weight: bold'>Can the manuscript pass the transparency assessment if the research study was not pre-registered?</li>
      <b>Yes</b>, at Level 2 this is not a requirement for study design analysis.
            <br></br>
      <li style='color: #cfabed; font-weight: bold'> If the research study was preregistered but there were deviations in the design and/or analysis can the preregistration guidelines be met?</li>
      <b>Yes</b>, but the deviations need to be transparently reported in the manuscript and you can confirm that in this app when requested.
                  <br></br>
      </h5>
      </ol>

      ")
    ),
    accordionItem(
      title = HTML("<h5 style='color: white; '><b>Tips for Manuscript Assessments</b></h5>"),
      status = "danger",
      collapsed = TRUE,
      HTML("<h5 style>
      <li style='color: #ffffff'>When providing a URL(s) to study data, code, or materials, make sure it is reliable and publicly accessible and links directly to the repository containing the specific data for the study.</h5></li>

      
      ")
    )
  )
)