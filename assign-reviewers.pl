# This is the bare beginings of an attempt to automate the process of randomly assigning
# review articles to students.  The problem is tricky because there are a lot of constraints.
# Problem:  assign $num_students students to review $num_articles articles $num_reviews times.
# Students are grouped together such that all the students in a group are the main editors of
# one article.
# Constraints:
#   - no student can ever be assigned to review his/her own article
#   - no student should review the same article twice
#   - reviewers must be evenly distributed.  that is, each article should get the same number
#     of reviewers, possibly off-by-one, if $num_students is not dividible by $num_articles.
#   - during any one review cycle, it would be nice to avoid the case where A is reviewing B's
#     article, and B is reviewing A's (but this is not critical).


use List::Util 'shuffle';
use Data::Dumper;

# Initialize "move array", which is an array of $num_students arrays of $num_reviews
# of random numbers:
# [ [ 8 6 2 1 5 4 7 3 0 ], [ ... ], [ ... ] ],
# [ [ 4 8 3 6 7 2 0 5 1 ], [ ... ], [ ... ] ],
# ... one for each student

$num_students = 17;
$num_reviews = 3;
$num_articles = 8;

my $move_array = [];
for (my $student_num = 0; $student_num < $num_students; ++$student_num) {
    my $student_moves = [];
    for (my $review_num = 0; $review_num < $num_reviews; ++$review_num) {
        my @moves = shuffle ( 0..$num_articles );
        push @$student_moves, \@moves;
    }
    push @$move_array, $student_moves;
}

# Also keep track of exactly what index we are on for each student, times
# three reviews, starts out as -1, meaning the student is not assigned to an article
# [ [ -1, -1, -1, ... ], [ -1, -1, -1, ... ], [ -1, -1, -1, ... ] ]

my $move_pointers = [];
for (my $review_num = 0; $review_num < $num_reviews; ++$review_num) {
    my $review_pointers = [];
    for (my $student_num = 0; $student_num < $num_students; ++$student_num) {
        push @$review_pointers, -1;
    }
    push @$move_pointers, $review_pointers;
}

# Finally, we need to know which student should be next, for each review:
my $student_pointers = [];
for (my $review_num = 0; $review_num < $num_reviews; ++$review_num) {
    push @$student_pointers, 0;
}

my $move_board = {
    'num_students'     => $num_students,
    'num_reviews'      => $num_reviews,
    'num_articles'     => $num_articles,

    'move_array'       => $move_array,
    'move_pointers'    => $move_pointers,
    'student_pointers' => $student_pointers,
    'review_pointer'   => 0,
};
print Dumper $move_board;

# We are done when every student has been assigned an article for each of three reviews
sub done {
    my $move_board = shift;
    my $num_students = $move_board->{num_students};
    my $student_pointers = $move_board->{student_pointers};
    for (my $review_num = 0; $review_num < $num_reviews; ++$review_num) {
        if ($student_pointers->[$review_num] != $num_students) {
            return false;
        }
    }
    return true;
}

sub make_next_move {
    my $move_board = shift;
    my $move_pointers = $move_board->{move_pointers};
    my $student_pointers = $move_board->{student_pointers};
    my $review_pointer = $move_board->{review_pointer};

    my $sp = $student_pointers->[$review_pointer];
}