module EventModule
  def dates_cannot_be_in_the_past
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.date_in_the_past')) if starts_at && starts_at < Date.today
    errors.add(I18n.t('time.ends_at'), I18n.t('errors.messages.date_in_the_past')) if ends_at && ends_at < Date.today
  end
  def start_before_end_date
    errors.add(I18n.t('time.starts_at'), I18n.t('errors.messages.start_date_not_before_end_date')) if starts_at && starts_at && ends_at < starts_at
  end
end