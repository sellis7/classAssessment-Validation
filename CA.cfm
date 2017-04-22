<!--- NOTE: Second modification of the page for more responsive behavior,
 but required adapting of validation code, and some cleanup --->

<!--- pagebuilder include --->


<CFSET debug=1>


<CFTRY>

	<CFSET THISSTUCA = URL.sca>

	<style>
		span.submit-warning,
		span.submit-warning-incomplete {
			/*display: block;*/
			position: relative;
			margin: 2px 4px;
			padding: 4px 10px;
			max-width:225px;
			/*float: right;*/
			border-radius: 4px;
			color: #a94442;
			font-size: .8em;
			background-color: #f2dede;
			border: 1px solid #ebccd1;
		}
	</style>

<script language="javascript">
	function textLimit(field, maxlen) {
		if (field.value.length > maxlen + 1)
			alert('@GETMSG(CA_CommentMaxLen) '+maxlen+' @GETMSG(APP_Characters).');
		if (field.value.length > maxlen)
			field.value = field.value.substring(0, maxlen);
		}
</script>


<CFSET debug=2>
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
<CFSET debug=3>


<CFIF caname.fkey_assessment_status EQ 1 >
	<font class="mainalt"><BR><BR>@GETMSG(CA_NotEligible) </font>
<CFELSEIF caname.fkey_assessment_status EQ 3>
	<font class="mainalt"><BR><BR>@GETMSG(CA_AlreadyCompleted)</font>
<CFELSE>

	<cfset variables.thisAssessmentKey = caname.fkey_assessment>
	<cfquery name="listOfAllQ" datasource="#db.connect#">
		SELECT	distinct stu_CA_q.fkey_CA_q, obj_no
		FROM		stu_CA_q with (nolock),
				CA_obj_q_map with (nolock),
				CA_obj with (nolock),
				CA_q with (nolock)
		WHERE	stu_CA_q.fkey_CA_obj = CA_obj_q_map.fkey_CA_obj
				and CA_obj_q_map.fkey_CA_obj = key_CA_obj
				and fkey_stu_CA = #THISSTUCA#
				and fkey_assessment = #variables.thisAssessmentKey#
				and stu_CA_q.fkey_CA_q = CA_q.key_CA_q
		ORDER BY	obj_no, stu_CA_q.fkey_CA_q
	</cfquery>
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


	<SCRIPT type="text/Javascript">
		function checkEntries(num) {
			//var i = 0;
			var entry = '';

			if (num > 1) {
				for (var i = 0; i < num; i++) {
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
					//$("textarea").each(function (){ BEHAVIOR NOW PROBABLY NOT NEEDED (S.E.)
						//var tArea = this;
						//if(tArea.required && (tArea.value == "" || tArea.value.includes("<Comments>"))){
							//var warningTxt = document.createElement('span');
							//warningTxt.innerText = "Required field";
							//warningTxt.className = "submit-warning-incomplete";
							//tArea.parentNode.appendChild(warningTxt);
						//}
					//});
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



<cfoutput>#caname.assessment_header#</cfoutput>

<FORM name="form1" id="form1" action="../pagebuilder/showPage.cfm?pagedef=caSubmit&<CFOUTPUT>#URLTOKEN#</CFOUTPUT>" method="post">

<style>
    div.pageHeader{}
    div.headerData{}
    div.headerData label:hover{cursor:auto;}
    div.headerData span{}

</style>

<div class="pageHeader">
	<CFOUTPUT>
	<h3>#caname.assessment_name#</h3>
	<div class="headerData">
		<label>@GETMSG(APP_Course):</label><span>#crsInfo.course_name#</span>
		<br>
		<label>@GETMSG(APP_Student):</label><span>#qStudentInfo.first_name# #qStudentInfo.last_name#</span>
	</div>
	<INPUT type="submit" class="btn" value="@GETMSG(CA_SubmitAssessment)" onClick="return validateForm(#NUMELEMS#)">
	</cfoutput>
</div>

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


<div class="table-responsive" id="survey">

	<CFLOOP query="obj">
		<CFQUERY name="q" datasource="#db.connect#"  timeout="#db.timeout#">
			SELECT		fkey_CA_q,ans_text,fkey_ca_ans,
						rtrim(question) as question
			FROM		CA_q,
						stu_CA_q
			WHERE 		fkey_CA_q = key_CA_q
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

		<BR><B><CFOUTPUT>#obj.objective#</CFOUTPUT></B>&nbsp;<BR>

		<CFLOOP query="q">
			<CFQUERY name="ans" datasource="#db.connect#"  timeout="#db.timeout#">
				SELECT		key_CA_ans,
							rtrim(answer) as answer
				FROM		CA_ans
				WHERE		fkey_CA_q = #q.fkey_CA_q#
				ORDER BY 	ans_item
			</CFQUERY>

			<CFSET ANSNO = 1>

			<CFSET THIS_Q = q.fkey_CA_q>
				<INPUT type="hidden" name="q_key" id="q_key-<cfoutput>#q.fkey_CA_q#</cfoutput>" value="<CFOUTPUT>#q.fkey_CA_q#</CFOUTPUT>">
				<INPUT type="hidden" name="a_key" id="a_key-<cfoutput>#q.fkey_CA_q#</cfoutput>" value="0">
			<CFOUTPUT>#CTR#</CFOUTPUT>.&nbsp;
			<CFOUTPUT><span id="theQuestion-#q.fkey_CA_q#">#q.question#&nbsp;</span></CFOUTPUT>

				<CFIF ans.recordCount EQ 0>
					<!--- Text Entry Answer --->
					<div id="comment_<CFOUTPUT>#fkey_CA_q#</CFOUTPUT>">
						<TEXTAREA class="main" name="q_cmt" id="<cfoutput>#ans.key_CA_ans#</cfoutput>-q_cmt" style="width:100%" rows="3"
						 onkeyup="textLimit(this, 1000);" aria-labelledby="theQuestion-<cfoutput>#q.fkey_CA_q#">#q.ans_text#</cfoutput></TEXTAREA>
					</div>

				<CFELSE>
					<!--- Multiple Choice Answer --->
					<Z:Table id="ztable_body-<cfoutput>#CTR#</cfoutput>" cols="" class="ztable_body" format="table">
						<row>
							<CFLOOP query="ans">
							<cfoutput>
									<data width="30" valign="top" aria-labelledby="#ans.key_CA_ans#-ansGroup_#THIS_Q#">

										<INPUT type="radio" name="ansGroup_#THIS_Q#" id="#ans.key_CA_ans#-ansGroup_#THIS_Q#" value="#ans.key_CA_ans#"
										<CFIF #q.fkey_ca_ans# EQ #ans.key_CA_ans#> Checked</CFIF>
										onClick="document.form1.a_key<CFIF #TOT# GT 1>[#CTR#-1]</CFIF>.value='#ans.key_CA_ans#';" aria-labelledby="theQuestion-#q.fkey_CA_q#" >
										<input type="hidden" name="ansNo_#THIS_Q#_#ans.key_CA_ans#" id="ansNo_#THIS_Q#_#ans.key_CA_ans#" value="#ANSNO#" / disabled >

									<CFOUTPUT>#ans.answer# <CFIF ANSNO LTE #caname.min_score_require_input#> (Comment Required)</CFIF></CFOUTPUT>&nbsp;</data>
							</cfoutput>
							<CFSET ANSNO = ANSNO + 1>
							</CFLOOP>
						</row>
					</Z:Table>

					<div id="comment_<CFOUTPUT>#fkey_CA_q#</CFOUTPUT>">
						<CFIF len(trim(q.ans_text)) GT 0>
							<cfset holder= q.ans_text>
						<CFELSE>
							<cfset holder= "@GETMSG(CA_CommentFiller)">
						</CFIF>


						<cfoutput>
							<label>Comments:&nbsp</label><span id="commentSpan__#THIS_Q#" class="commentSpan"><TEXTAREA class="main" name="q_cmt" id="#ans.key_CA_ans#-q_cmt" style="width: 100%" rows="3" onkeyup="textLimit(this, 1000);" onFocus="if(this.value==this.defaultValue)this.value='';" onblur="if(this.value=='')this.value=this.defaultValue;"><!--- <CFIF len(trim(#q.ans_text#)) GT 0><CFOUTPUT>#q.ans_text#</CFOUTPUT><CFELSE>@GETMSG(CA_CommentFiller)</CFIF> ---><cfoutput>#holder#</cfoutput></TEXTAREA></span>
						</cfoutput>
						<BR>
					</div>
				</CFIF>


			<CFSET CTR = CTR + 1>
		</CFLOOP>

	</CFLOOP>

 </div>

<cfoutput>
	<INPUT type="submit" class="btn" value="@GETMSG(CA_SubmitAssessment)" onClick="return validateForm(#NUMELEMS#)">
</cfoutput>

</FORM>

</CFIF>

<CFCATCH>

	<CFOUTPUT>
		#cfcatch.message#<BR>#cfcatch.detail#<BR>debug=#debug#<BR>
		<cfdump var="#cfcatch#">
		<cfdump var="#cgi#">
	</cfoutput>
</CFCATCH>
</CFTRY>
