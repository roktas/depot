#!/usr/bin/env ruby

require "pathname"
require "yaml"

ALLOWED_FRONTMATTER = %w[allowed-tools description license metadata name].freeze
REQUIRED_INTERFACE = %w[default_prompt display_name short_description].freeze

class Audit
  def initialize(root)
    @errors = []
    @root = Pathname(root)
  end

  def run
    skills = @root.children.sort.select { |path| path.directory? || path.symlink? }
    skills.each { |skill| inspect_skill(skill) }

    if @errors.empty?
      label = skills.one? ? "skill" : "skills"
      puts("validated #{skills.length} #{label}")
      return
    end

    @errors.each { |error| warn("E: #{error}") }
    exit(1)
  end

  private

  def inspect_frontmatter(skill, source)
    match = source.match(/\A---\n(.*?)\n---\n/m)
    return error(skill, "invalid SKILL.md frontmatter") unless match

    data = load_yaml(skill.join("SKILL.md"), match[1])
    return unless data

    unexpected = data.keys.map(&:to_s) - ALLOWED_FRONTMATTER
    error(skill, "unexpected frontmatter keys: #{unexpected.sort.join(", ")}") unless unexpected.empty?
    error(skill, "frontmatter name does not match directory") unless data["name"] == skill.basename.to_s
    error(skill, "description is missing") unless data["description"].is_a?(String) && !data["description"].strip.empty?
  end

  def inspect_interface(skill)
    path = skill.join("agents/openai.yaml")
    return error(skill, "missing agents/openai.yaml") unless path.file?

    data = load_yaml(path)
    return unless data

    interface = data["interface"]
    return error(skill, "openai.yaml has no interface mapping") unless interface.is_a?(Hash)

    missing = REQUIRED_INTERFACE - interface.keys.map(&:to_s)
    error(skill, "missing interface keys: #{missing.join(", ")}") unless missing.empty?

    description = interface["short_description"]
    unless description.is_a?(String) && description.length.between?(25, 64)
      error(skill, "short_description must contain 25-64 characters")
    end

    prompt = interface["default_prompt"]
    unless prompt.is_a?(String) && prompt.include?("$#{skill.basename}")
      error(skill, "default_prompt must mention $#{skill.basename}")
    end
  end

  def inspect_links(skill)
    skill.glob("**/*.md").sort.each { |path| inspect_markdown_links(skill, path) }
  end

  def inspect_markdown_links(skill, path)
    source = searchable_markdown(path.read)

    source.scan(/\[[^\]]+\]\(([^)]+)\)/).flatten.each do |raw_target|
      target = link_target(raw_target)
      next unless target
      next if target.match?(%r{\A(?:[a-z][a-z0-9+.-]*:|//|/|#)}i)

      target_path = target.split(/[?#]/, 2).first
      next if target_path.empty?

      resolved = path.dirname.join(target_path).cleanpath

      next if resolved.exist?

      location = path.relative_path_from(skill)
      error(skill, "#{location}: broken local link: #{target}")
    end
  end

  def inspect_skill(skill)
    if skill.symlink?
      error(skill, "broken symbolic link") unless skill.exist?
      return
    end

    path = skill.join("SKILL.md")
    return error(skill, "missing SKILL.md") unless path.file?

    source = path.read
    error(skill, "SKILL.md exceeds 500 lines") if source.lines.length > 500
    inspect_frontmatter(skill, source)
    inspect_interface(skill)
    inspect_links(skill)
  end

  def link_target(raw_target)
    source = raw_target.strip
    return if source.empty?

    target = if source.start_with?("<")
      closing = source.index(">")
      return unless closing

      source[1...closing]
    else
      source.split(/[ \t\r\n]/, 2).first
    end

    return if target.empty? || target.count("(") != target.count(")")

    target
  end

  def load_yaml(path, source = path.read)
    data = YAML.safe_load(source, permitted_classes: [], aliases: false)
    return data if data.is_a?(Hash)

    @errors << "#{path}: YAML root must be a mapping"
    nil
  rescue Psych::Exception => e
    @errors << "#{path}: invalid YAML: #{e.message.lines.first.strip}"
    nil
  end

  def searchable_markdown(source)
    without_fences(source.gsub(/<!--.*?-->/m, ""))
      .gsub(/(`+).*?\1/, "")
  end

  def without_fences(source)
    fence_character = nil
    fence_length = 0
    output = +""

    source.each_line do |line|
      if fence_character
        if line.match?(/\A {0,3}#{Regexp.escape(fence_character)}{#{fence_length},}[ \t]*\r?\n?\z/)
          fence_character = nil
          fence_length = 0
        end

        next
      end

      marker = line.match(/\A {0,3}(`{3,}|~{3,})/)
      if marker
        fence_character = marker[1][0]
        fence_length = marker[1].length
        next
      end

      output << line
    end

    output
  end

  def error(skill, message)
    @errors << "#{skill.relative_path_from(@root)}: #{message}"
  end
end

abort("usage: #{File.basename($PROGRAM_NAME)} [SKILL_ROOT]") if ARGV.length > 1

root = if ARGV.empty?
  Pathname(__dir__).join("../skills").cleanpath
else
  Pathname(ARGV.fetch(0)).expand_path
end

abort("skill root not found: #{root}") unless root.directory?

Audit.new(root).run
