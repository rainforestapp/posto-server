class DateHelper
  def self.printable_age(date_to_compare_to, birthday, pluralize = true)
    return unless date_to_compare_to > birthday
    return if date_to_compare_to - birthday < 60 * 60 * 25

    diff = date_to_compare_to - birthday
    number_of_days = (diff / (24 * 60 * 60)).floor

    number_of_months_old = 0
    number_of_extra_days_old = 0
    current = birthday

    month_incremented_this_month = true

    loop do
      current += 1.day

      if current.day == 1
        if !month_incremented_this_month && birthday.day != 1
          number_of_months_old += 1
          number_of_extra_days_old = 0
        end

        month_incremented_this_month = false
      end

      if current.day == birthday.day
        number_of_months_old += 1
        number_of_extra_days_old = 0
        month_incremented_this_month = true
      elsif current.day < birthday.day
        number_of_extra_days_old += 1
      end

      break if current.day == date_to_compare_to.day && current.month == date_to_compare_to.month && current.year == date_to_compare_to.year
    end

    number_of_years_old = number_of_months_old / 12
    number_of_extra_months_old = number_of_months_old % 12
    number_of_weeks_old = (number_of_months_old * 4) + (number_of_extra_days_old / 7)

    syear = number_of_years_old > 1 && pluralize ? "years" : "year"
    smonth = number_of_months_old > 1 && pluralize ? "months" : "month"
    sday = number_of_extra_days_old > 1 && pluralize ? "days" : "day"
    sweek = number_of_weeks_old > 1 && pluralize ? "weeks" : "week"

    if number_of_years_old > 0
      if number_of_extra_months_old == 6
        "#{number_of_years_old} and a half #{pluralize ? "years" : "year"}"
      else
        if number_of_extra_months_old > 0
          "#{number_of_years_old} #{syear} and #{number_of_extra_months_old} #{smonth}"
        else
          "#{number_of_years_old} #{syear}"
        end
      end
    else
      if number_of_weeks_old == 0
        "#{number_of_extra_days_old} #{sday}"
      elsif number_of_months_old == 0
        "#{number_of_weeks_old} #{sweek}"
      elsif number_of_months_old <= 6
        if number_of_extra_days_old < 8
          "#{number_of_months_old} #{smonth}"
        elsif number_of_extra_days_old < 15
          "#{number_of_weeks_old} #{sweek}"
        elsif number_of_extra_days_old < 22
          "#{number_of_months_old} and a half #{smonth}"
        else
          "#{number_of_weeks_old} #{sweek}"
        end
      else
        if number_of_extra_days_old < 14
          "#{number_of_months_old} #{smonth}"
        else
          "#{number_of_months_old} and a half #{smonth}"
        end
      end
    end
  end
end
