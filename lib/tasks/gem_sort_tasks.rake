require 'gem_sort/sorter'

namespace :gem do
  task :sort do
    GemSort::Sorter.new.sort!
  end
end
