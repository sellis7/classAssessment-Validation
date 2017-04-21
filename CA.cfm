<CFINCLUDE template="#Client.custom_path#/constants.cfm">

<cfif NOT IsDefined("url.pagedef")>
	<cflocation url="../pagebuilder/showpage.cfm?pagedef=admpopup&loc=Stu_CA&goto=CA&#cgi.query_string#" addtoken="false" />
</cfif>

<CFTRY>
<script language="javascript">
function textLimit(field, maxlen) {
if (field.value.length > maxlen + 1)
alert('Comments can be only be up to '+maxlen+' characters.');
if (field.value.length > maxlen)
field.value = field.value.substring(0, maxlen);
}
</script>

<CFSET THISSTUCA = URL.sca>
	<CFQUERY name="caname" datasource="#db.connect#" timeout="#db.timeout#">
		SELECT	assessment.assessment_name,
					assessment.assessment_header,
					ca.fkey_assessment,
					ca.fkey_course,
					key_stu_CA,fkey_assessment_status,
					first_name,
					last_name,
					isnull(min_score_require_input, 0) AS min_score_require_input
		FROM		ca,stu_registration,
					assessment,
					stu_ca left outer join contact on
						fkey_inst = key_contact
		WHERE		stu_ca.fkey_ca = ca.key_ca 
					and ca.fkey_assessment = assessment.key_assessment
					and key_stu_CA = #THISSTUCA#
					and stu_ca.fkey_reg=stu_registration.key_reg
		ORDER BY	assessment.assessment_name
	</CFQUERY>

<CFIF caname.fkey_assessment_status EQ 1 >

<font class="mainalt"><BR><BR>You are not eligible to take the assessment at this time. </font>

<CFELSEIF caname.fkey_assessment_status EQ 3>

<font class="mainalt"><BR><BR>You have already completed this assessment. </font>

<CFELSE>

	<cfset variables.thisAssessmentKey = caname.fkey_assessment>

<cfquery name="qStudentInfo" datasource="#db.connect#" timeout="#db.timeout#">
	SELECT	fkey_reg,
				contact.last_name,
				contact.first_name, stu_registration.fkey_course
	FROM		stu_CA
				INNER JOIN stu_registration ON
					fkey_reg = key_reg
				INNER JOIN student ON
					fkey_student = key_student
				INNER JOIN contact ON
					fkey_contact = key_contact
	WHERE		key_stu_CA = #THISSTUCA#
</cfquery>

<CFQUERY name="crsInfo" datasource="#db.connect#"  timeout="#db.timeout#">
	SELECT	top 1 rtrim(course_id) as course_id,
				rtrim(course_name) as course_name
	FROM		course_core_data
	WHERE		key_course = #qStudentInfo.fkey_course#
</CFQUERY>

<CFQUERY name="cnt" datasource="#db.connect#"  timeout="#db.timeout#">
	SELECT	*
	FROM		stu_CA_q
	WHERE		fkey_stu_CA = #THISSTUCA#
</CFQUERY>

<CFSET NUMELEMS = cnt.recordCount>

<HTML>
<HEAD>
	<TITLE>
		<CFOUTPUT>#caname.assessment_name# <CFIF Len(caname.first_name) GT 0> for #caname.first_name# #caname.last_name#</CFIF></CFOUTPUT>
	</TITLE>
	
	<cfoutput>
	<link rel=StyleSheet href="#Client.custom_path#/styleLMS.css">
	</cfoutput>

	<cfquery name="listOfAllQ" datasource="#db.connect#">
		SELECT	distinct stu_CA_q.fkey_CA_q, obj_no
		FROM		stu_CA_q,
				CA_obj_q_map,
				CA_obj,
				CA_q
		WHERE	stu_CA_q.fkey_CA_obj = CA_obj_q_map.fkey_CA_obj
				and CA_obj_q_map.fkey_CA_obj = key_CA_obj
				and fkey_stu_CA = #THISSTUCA#
				and fkey_assessment = #variables.thisAssessmentKey#
				and stu_CA_q.fkey_CA_q = CA_q.key_CA_q
		ORDER BY	obj_no, stu_CA_q.fkey_CA_q
	</cfquery>
	<style>
		span.submit-warning,
		span.submit-warning-incomplete {
			margin: 2px 15px 0 0;
			padding: 6px 10px;
			float: right;
			border-radius: 4px;
			color: #a94442;
			background-color: #f2dede;
			border: 1px solid #ebccd1;
		}
	</style>
	
	<SCRIPT type="text/Javascript">
		function checkEntries(num) {
			var i = 0;
			var entry = '';
			if (num > 1) {
				for (i = 0; i < num; i++) {
					entry = document.form1.q_cmt[i].value;
					while (entry.substring(0,1) == ' ') {
					  entry = entry.substring(1,entry.length);
					}
					while (entry.substring(entry.length-1,entry.length) == ' ') {
					  entry = entry.substring(0,entry.length-1);
					}
					if (entry.length == 0 || entry == '<Comments>'){
						document.form1.q_cmt[i].value = '-';
					}
					else {
						while (entry.indexOf(',') >= 0) {
							entry = entry.replace(',','^');
						}
						document.form1.q_cmt[i].value = entry;
					}
				}
			}
			else {
				entry = document.form1.q_cmt.value;
				while (entry.substring(0,1) == ' ') {
					entry = entry.substring(1,entry.length);
				}
				while (entry.substring(entry.length-1,entry.length) == ' ') {
					entry = entry.substring(0,entry.length-1);
				}
				if (entry.length == 0 || entry == '<Comments>') {
					document.form1.q_cmt.value = '-';
				}
				else {
					while (entry.indexOf(',') >= 0) {
						entry = entry.replace(',','^');
					}
					document.form1.q_cmt.value = entry;
				}
			}
		}
		
		function validateForm(num){
			// **** ORIGINAL CODE var curr_key_CA_ans = 0;
			// var selected_ans_no = 0;
			// var min_score_require_input = <!--- <cfoutput>#caname.min_score_require_input#</cfoutput> --->;
			// $('.commentSpan').css("background-color", "");
			<!--- <cfoutput query="listOfAllQ">
				curr_key_CA_ans = $('input[name=ansGroup_<cfoutput>#listOfAllQ.fkey_CA_q#</cfoutput>]:checked').val();
				selected_ans_no = $('##ansNo_<cfoutput>#listOfAllQ.fkey_CA_q#</cfoutput>_' + key_CA_ans).val();
				if(selected_ans_no < min_score_require_input){
					$('##commentSpan_<cfoutput>#listOfAllQ.fkey_CA_q#</cfoutput>').css("background-color", "##F3F693");
				}
			</cfoutput> --->
			//edit comments so it can be processed by apply page...
			// checkEntries(num);
			//return true; ****** END OF ORIGINAL CODE

			var elementCt = 0;
			$("textarea").each(function (){
				var tArea = this;
				if(tArea.required && (tArea.value == "" || tArea.value.includes("<Comments>"))){
					elementCt++;
				}
			});

			if(elementCt != 0){ // if count incremented due to incomplete required textareas
				var x = document.querySelectorAll("span.submit-warning");
				// if there are no current warnings, create them
				if(x.length != 2 ){
					$("textarea").each(function (){
						var tArea = this;
						if(tArea.required && (tArea.value == "" || tArea.value.includes("<Comments>"))){
							var warningTxt = document.createElement('span');
							warningTxt.innerText = "Required field";
							warningTxt.className = "submit-warning-incomplete";
							tArea.parentNode.appendChild(warningTxt);
						}
					});
					var showWarning = document.querySelectorAll('input.btn');
					for(i=0; i < showWarning.length; i++){
						var warningTxt = document.createElement('span');
						warningTxt.innerText = "Please complete highlighted fields";
						warningTxt.className = "submit-warning";
						showWarning[i].parentNode.appendChild(warningTxt);
					}
				}
				elementCt = 0;
				return false;
			} else {
				checkEntries(num);
				return true;
			}
			return false;
		}

		$(document).on("change", "input[type=radio]", function() {
			// checks value of radio btn & if comment field is required
			var min_score = <cfoutput>#caname.min_score_require_input#</cfoutput>;
			var qGroup = this.name.replace(/^[^_]*_/,"");
			var qID = "commentSpan__" + qGroup;			
			if($(this).next().val() <= min_score){
				$('#'+qID+' textarea').css("background-color", "##F3F693").prop('required', true);
			} else { 
				$('#'+qID+' textarea').css("background-color", "").prop('required', false);
			}
		});

	</SCRIPT>
</HEAD>

<body class="homePg">

<cfoutput>#caname.assessment_header#</cfoutput>
<cfoutput>
<FORM name="form1" id="form1" action="../Stu_CA/submit_CA.cfm?#URLTOKEN#" method="post">

<table width="100%"   class="header" >
	<tr>
    	<td valign="top">
    		<table width="780" align="center">
	        	<tr> 
					<td class="h2"  >
						<cfoutput>
							<br>#caname.assessment_name# <CFIF Len(caname.first_name) GT 0> for #caname.first_name# #caname.last_name#</CFIF>
						</cfoutput>
					</td>
				</tr>
				<tr> 
					<td class="h2" >
						<cfoutput>
						<B>Course: #crsInfo.course_name#</B>
						</cfoutput>
	               	</td>
	        	</tr>
				<tr> 
					<td   class="h2" >
						<cfoutput>
						 #student_display_name#: #qStudentInfo.first_name# #qStudentInfo.last_name#
						</cfoutput>
	               	</td>
	        	</tr>
				<tr>
					<td class="h2" >
						<cfoutput>
						<INPUT type="submit" class="btn" value="Submit" onClick="return validateForm(#NUMELEMS#)">
						</cfoutput>
	               	</td>
	        	</tr>
      		</table>
		</td>
	</tr>
</table>

<cfoutput>
<INPUT type="hidden" name="sca" id="sca" value="#THISSTUCA#">
</cfoutput>

<CFQUERY name="obj" datasource="#db.connect#"  timeout="#db.timeout#">
	SELECT	distinct stu_CA_q.fkey_CA_obj,
				rtrim(objective) as objective,
				obj_no
	FROM		stu_CA_q,
				CA_obj_q_map,
				CA_obj
	WHERE		stu_CA_q.fkey_CA_obj = CA_obj_q_map.fkey_CA_obj
				and CA_obj_q_map.fkey_CA_obj = key_CA_obj
				and fkey_stu_CA = #THISSTUCA#
				and fkey_assessment = #variables.thisAssessmentKey#
	ORDER BY	obj_no
</CFQUERY>

<CFSET CTR = 1>

<TABLE width="700" class="homepg">
<CFLOOP query="obj">
	<CFQUERY name="q" datasource="#db.connect#"  timeout="#db.timeout#">
		SELECT	fkey_CA_q,ans_text,fkey_ca_ans,
					rtrim(question) as question
		FROM		CA_q,
					stu_CA_q
		WHERE		fkey_CA_q = key_CA_q
					and fkey_CA_obj = #obj.fkey_CA_obj#
					and fkey_stu_CA = #THISSTUCA#
		ORDER BY	key_CA_q
	</CFQUERY>

	<CFQUERY name="numberq" datasource="#db.connect#"  timeout="#db.timeout#">
		SELECT	1
		FROM		
					stu_CA_q
		WHERE				
					fkey_stu_CA = #THISSTUCA#

	</CFQUERY>

	<CFSET TOT = #numberq.recordCount#>

	<TR class="homepg">
		<TD colspan=4><BR><h2 class="submenu2"><CFOUTPUT>#obj.objective#</CFOUTPUT></h2>&nbsp;</TD>
	</TR>

	<CFLOOP query="q">

		<CFQUERY name="ans" datasource="#db.connect#"  timeout="#db.timeout#">
			SELECT	key_CA_ans,		 
						rtrim(answer) as answer
			FROM		CA_ans
			WHERE		fkey_CA_q = #q.fkey_CA_q#
			ORDER BY	ans_item
		</CFQUERY>

		<CFSET ANSNO = 1>

		<CFSET THIS_Q = q.fkey_CA_q>
		<TR class="homepg">
			<TD width="30">&nbsp;
				<INPUT type="hidden" name="q_key" id="q_key-#q.fkey_CA_q#" value="<CFOUTPUT>#q.fkey_CA_q#</CFOUTPUT>">
				<INPUT type="hidden" name="a_key" id="a_key-#q.fkey_CA_q#" value="0">
			<TD width="30" align="right" valign="top"><BR><CFOUTPUT>#CTR#</CFOUTPUT>.&nbsp;</TD>
			<TD colspan="2" width="640"><BR><legend id="theQuestion-#q.fkey_CA_q#"><CFOUTPUT>#q.question#</CFOUTPUT></legend>&nbsp;</TD>
		</TR>

		<CFIF ans.recordCount EQ 0>
			<!--- Text Entry Answer --->
			<TR class="homepg">
				<TD width="30">&nbsp;</TD>
				<TD width="30">&nbsp;</TD>
				<TD colspan="4" width="640">
					<TEXTAREA class="main" name="q_cmt" id="#ans.key_CA_ans#-q_cmt" style="width: 620px" rows="2" 
					 onkeyup="textLimit(this, 1000);"><CFOUTPUT>#q.ans_text#</CFOUTPUT></TEXTAREA>
				</TD>
			</TR>
		<CFELSE>
			<!--- Multiple Choice Answer --->
			<CFLOOP query="ans">
				<TR class="homepg">
					<TD width="30">&nbsp;</TD>
					<TD width="30">&nbsp;</TD>
					<TD width="30" valign="top">
						<cfoutput>
							<INPUT type="radio" name="ansGroup_#THIS_Q#" id="#ans.key_CA_ans#-ansGroup_#THIS_Q#" value="#ans.key_CA_ans#"
							<CFIF #q.fkey_ca_ans# EQ #ans.key_CA_ans#> Checked</CFIF>
							onClick="document.form1.a_key<CFIF #TOT# GT 1>[#CTR#-1]</CFIF>.value='#ans.key_CA_ans#';" aria-labelledby="theQuestion-#q.fkey_CA_q#" >	
							<input type="hidden" name="ansNo_#THIS_Q#_#ans.key_CA_ans#" id="ansNo_#THIS_Q#_#ans.key_CA_ans#" value="#ANSNO#" />
						</cfoutput>

					</TD>
					<TD width="310" valign="top" aria-labelledby="#ans.key_CA_ans#-ansGroup_#THIS_Q#"><CFOUTPUT>#ans.answer#	<CFIF ANSNO LTE #caname.min_score_require_input#> (Comment Required)</CFIF>	</CFOUTPUT>&nbsp;</TD>
					<CFIF ANSNO EQ 1>
						<cfoutput>
						
						<TD width="300" valign="top" rowspan="#ans.recordCount#">
							<span id="commentSpan__#THIS_Q#" class="commentSpan">
							<TEXTAREA class="main" name="q_cmt" id="#ans.key_CA_ans#-q_cmt" style="width: 206px" rows="3" 
							onkeyup="textLimit(this, 1000);" ><CFIF len(trim(#q.ans_text#)) GT 0><CFOUTPUT>#q.ans_text#</CFOUTPUT><CFELSE> <Comments></CFIF></TEXTAREA>
							</span>
						</TD>
						</cfoutput>
					</CFIF>
				</TR>

				<CFSET ANSNO = ANSNO + 1>
			</CFLOOP>
		</CFIF>

		<CFSET CTR = CTR + 1>
	</CFLOOP>
</CFLOOP>
<tr>				
	<td colspan="5">&nbsp;</td>
</tr>
<tr>				
	<td colspan="5" align="middle">
		<cfoutput>
			<INPUT type="submit" class="btn" value="Submit" onClick="return validateForm(#NUMELEMS#)">
		</cfoutput>
	</td>
</tr>
</TABLE>
</FORM>
</cfoutput>

</CFIF>

<CFCATCH>
	<CFOUTPUT>#cfcatch.message#<BR>#cfcatch.detail#<BR> </cfoutput>
</CFCATCH>
</CFTRY>

</BODY>
</HTML>
