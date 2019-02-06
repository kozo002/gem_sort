module GemSort
  class Sorter
    def extract_blocks!(lines, begin_block_condition, nested = false)
      end_block_condition = -> (line) {
        (nested ? line.strip : line).start_with?("end")
      }
      blocks = []

      while lines.select(&begin_block_condition).length > 0
        begin_block_index = lines.index(&begin_block_condition)
        block_length = lines
          .slice(begin_block_index..lines.length)
          .index(&end_block_condition)
        block_length += 1
        blocks <<  lines.slice!(begin_block_index, block_length)
      end
      blocks
    end

    def extract_line!(lines, condition)
      target_line = lines.select(&condition).first
      lines.delete_if{ |line| line == target_line } if target_line != nil
      target_line
    end

    def sort_block_gems(block)
      wrap_block(block, sort_gems(unwrap_block(block)))
    end

    def wrap_block(block, inside)
      [
        block.first,
        *inside,
        block.last
      ]
    end

    def unwrap_block(block)
      block[1..block.length - 2]
    end

    def inject_between(array, divider)
      array.each_with_index.inject([]) { |acc, (item, i)|
        acc << item
        acc << divider if array.last != item
        acc
      }
    end

    def sort_gems(gems)
      gems.each { |line| line.gsub!(/\"/,"'") }.sort
    end

    def source_gemfile
      ::Rails.root.join('Gemfile').open('r+')
    end

    def initialized_gemfile
      ::Rails.root.join('Gemfile').open('w')
    end

    def read_gemfile
      source_gemfile.read.split("\n").select{ |line| line != "" }
    end

    def removal_comment_and_blank(text)
      text.gsub(/#[^{].*$/,'').gsub(/\n(\s|　)*\n/, "\n\n").gsub(/( |　)+/, ' ')
    end

    def magic_comment
      "# frozen_string_literal: true\n"
    end

    def write_gemfile(text)
      initialized_gemfile.write(magic_comment + removal_comment_and_blank(text))
    end


    def sort!
      gemfile = read_gemfile

      group_blocks = extract_blocks!(gemfile, -> (line) {
        line.start_with?("group")
      }).map{ |group_block|
        sort_block_gems(group_block)
      }

      source_blocks = extract_blocks!(gemfile, -> (line) {
        line.start_with?("source ") && line.end_with?("do")
      }).map{ |source_block|
        source_inside = unwrap_block(source_block)
        inside_group_blocks = extract_blocks!(source_inside, -> (line) {
          line.strip.start_with?("group")
        }, true).map{ |inside_group_block|
          sort_block_gems(inside_group_block)
        }
        inside = source_inside.sort + inject_between(inside_group_blocks, nil)
        wrap_block(source_block, inside)
      }

      source_line = extract_line!(gemfile, -> (line) {
        line.start_with?('source') && !line.end_with?('do')
      })

      git_source_line = extract_line!(gemfile, -> (line) {
        line.start_with?('git_source')
      })

      ruby_line = extract_line!(gemfile, -> (line) {
        line.start_with?('ruby')
      })

      rails_line = extract_line!(gemfile, -> (line) {
        line.start_with?('gem "rails"') || line.start_with?("gem 'rails'")
      })

      sorted_text = inject_between([
        [source_line, git_source_line],
        [ruby_line, rails_line],
        sort_gems(gemfile),
        inject_between(group_blocks, nil),
        inject_between(source_blocks, nil)
      ], nil).flatten.join("\n")

      write_gemfile(sorted_text)
    end
  end
end
