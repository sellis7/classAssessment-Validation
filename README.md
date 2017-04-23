## Student survey form validation

Established a way to validate a student-submitted survey offered once a student
had completed a course. This is within a commercially-used learning management system
mostly developed using ColdFusion. This file saw 2 further modifications since the
1st inception of the survey validation. Changes were needed when the initial structure
of the layout evolved from a basic table generated from a loop, then to a more
responsive-styled table layout, and afterward having additional conditional variables used
to determine whether completing all inputs were mandatory.

The only initial validation of sorts had been to check for comments within a textarea,
and if text hadn't been entered, the fields would be counted and a hyphen was placed as the
value to be inserted into a database as the resulting value. This was left, and additional
checks were added.

A combination of JavaScript and JQuery was used to determine if a chosen option necessitated
a required comment based on a hidden input value associated to that choice, once a question
was answered. Then the textarea field is highlighted and a required attribute is added to
the input to be checked. Should the option be chosen that did not require a comment,
the required attribute and highlight are removed. The validation then checks for the
required attribute and if there is a value in the textarea upon form submission. Depending on
the check, warnings were added to the fields and also provided near the submission buttons
(due to the survey length sometimes being extensive), or the form was submitted. The second
generation of this file didn't warrant the use of warnings at the inputs, and positioning
was modified where they appeared at the submit buttons.

The last generation of this file included a conditional variable provided through a
database query as a parameter to check against whether all inputs were to be completed
or optional. If this variable value was present, then all fields were necessary, if not
then validate the form as before.

Additionally, efforts were made to add ADA compliance to the form, and the behavior of
the textareas were changed to have the initial "placeholder" value disappear and reappear
when focus was placed on the inputs.

*The evolution of this file is available within the history, as the changes were committed
in 3 distinct steps.*
