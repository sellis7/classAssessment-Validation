## Student survey form validation

Established a validation of a student-submitted survey offered once a student completes 
a course. This is within a commercially-used learning management system mostly developed 
using ColdFusion. There were 3 modifications of the file, in total. Alterations were needed 
due to the initial structure of the layout going from a basic table to a more responsive-styled 
table layout, and lastly when additional conditional variables were added to determine whether 
completing all inputs were mandatory.

The only initial validation of sorts was to check for comments within a textarea, and if text 
hadn't been entered, the fields would be counted and a hyphen placed as the value to be inserted 
into the database. This remains, and additional checks were added.

Use of JavaScript and JQuery determine if a chosen option necessitates a required comment 
based on a hidden input value associated to that choice. Then the textarea is highlighted 
and a required attribute added to the input tag. Should a different option be chosen that 
doesn't require a comment, the required attribute and highlight are removed. Upon submission, 
the validation then checks for the required attribute and the value in the textarea. Depending on
the check, warnings are added to the fields and also near the submission buttons (due to the 
survey length sometimes being extensive), or the form is submitted. The second generation of this 
file didn't warrant the use of warnings at the inputs, and positioning was modified where warnings 
appear at the submit buttons.

The last generation of this file includes a conditional variable provided through a database query 
as a parameter to check against whether all inputs are to be completed or optional. If this variable 
value is present, then all fields are necessary – if not then validate the form as before.

Additionally, changes were made to add ADA compliance to the form, and the behavior of the textareas 
were changed to have the initial "placeholder" value disappear and reappear depending on focus.

*The evolution of this file is available within the history, as the changes were committed
in 3 distinct steps. A JPG file is also provided for a visual reference of the validation.*
