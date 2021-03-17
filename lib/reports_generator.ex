defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &sun_values/2)
  end

  defp sun_values(line, report) do
    all_hours = sum_all_hours(line, report.all_hours)
    hours_per_month = sum_hours_per_month(line, report.hours_per_month)
    hours_per_year = sum_hours_per_year(line, report.hours_per_year)

    build_report(all_hours, hours_per_month, hours_per_year)
  end

  defp sum_all_hours([freelancer, hour, _, _, _], all_hours) do
    acc_hour = Map.get(all_hours, freelancer, 0)
    Map.put(all_hours, freelancer, acc_hour + hour)
  end

  defp sum_hours_per_month([freelancer, hour, _, month, _], hours_per_month) do
    freelancer_month = Map.get(hours_per_month, freelancer, %{})
    acc_month = Map.get(freelancer_month, month, 0)
    new_month = Map.put(freelancer_month, month, acc_month + hour)
    Map.put(hours_per_month, freelancer, new_month)
  end

  defp sum_hours_per_year([freelancer, hour, _, _, year], hours_per_year) do
    freelancer_year = Map.get(hours_per_year, freelancer, %{})
    acc_year = Map.get(freelancer_year, year, 0)
    new_year = Map.put(freelancer_year, year, acc_year + hour)
    Map.put(hours_per_year, freelancer, new_year)
  end

  defp build_report(all_hours, hours_per_month, hours_per_year) do
    %{all_hours: all_hours, hours_per_month: hours_per_month, hours_per_year: hours_per_year}
  end

  defp report_acc(), do: %{all_hours: %{}, hours_per_month: %{}, hours_per_year: %{}}
end
