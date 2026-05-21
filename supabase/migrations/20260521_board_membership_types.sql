-- Board pricing tier — add board_monthly + board_yearly to membership_type
alter table public.profiles drop constraint if exists profiles_membership_type_check;
alter table public.profiles add constraint profiles_membership_type_check
  check (membership_type = any (array[
    'free', 'bundle', 'monthly', 'yearly',
    'mcq_monthly', 'mcq_yearly',
    'meq_monthly', 'meq_yearly',
    'longcase_monthly', 'longcase_yearly',
    'board_monthly', 'board_yearly'
  ]));
