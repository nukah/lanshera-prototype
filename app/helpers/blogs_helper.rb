module BlogsHelper
  def present_time(time)
    DateTime.parse(time.to_s).strftime("%d/%m/%Y | %H:%M")
  end
end