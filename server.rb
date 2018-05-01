require 'sinatra'

get '/' do
  <<-HTML
  <html>
    <ul>
      <li><a href="/training?class=lenny">Training Data (lenny)</a></li>
      <li><a href="/training?class=not-lenny">Training Data (not-lenny)</a></li>
      <li><a href="/results">Test Results</a></li>
    </ul>
  </html>
  HTML
end

get '/training' do
  <<-HTML
  <html>
    <style>
      img { image-orientation: from-image; }
    </style>
    #{Dir["classes/#{params["class"]}/*"].map { |path| "<img src='/img?path=#{path}' height=200/>" }.join("<br>")}
  </html>
  HTML
end

get '/img' do
  File.read(params["path"])
end

get '/results' do
  counts = {
    false_positive: 0,
    true_positive: 0,
    false_negative: 0,
    true_negative: 0
  }

  body =
    File.read('results.out').each_line.map do |line|
      path, c_one, c_one_confidence, c_two, c_two_confidence = line.rstrip.split("\t")
      result_class =
        if path.include?("not-lenny")
          conf = [[c_one, c_one_confidence], [c_two, c_two_confidence]].find { |(klass, _)| klass == "not lenny" }[1]
          conf.to_f > 0.5 ? :true_negative : :false_positive
        else
          conf = [[c_one, c_one_confidence], [c_two, c_two_confidence]].find { |(klass, _)| klass == "lenny" }[1]
          conf.to_f > 0.5 ? :true_positive : :false_negative
        end

      counts[result_class] += 1

      style =
        case result_class
        when :false_positive, :false_negative
          "background-color: red;"
        end

      "<li style='#{style}'>#{c_one} - #{c_one_confidence}, #{c_two} - #{c_two_confidence} <img src='/img?path=#{path}' height=200/></li>"
    end.join("<br>")

  <<-HTML
  <html>
    <style>
      img { image-orientation: from-image; }
    </style>
    <ul>
      <li>false_positives = #{counts[:false_positive]}</li>
      <li>true_positives = #{counts[:true_positive]}</li>
      <li>false_negatives = #{counts[:false_negative]}</li>
      <li>true_negatives = #{counts[:true_negative]}</li>
    </ul>

    <ul>
      #{body}
    </ul>
  </html>
  HTML
end
