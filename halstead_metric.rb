class HalsteadMetric

  @@PURE_OPS = [
      "+", "-",
      "!", "~", "**", "&", "*", "/", "%", "<<", ">>",
      "<", "<=", ">", ">=", "==", "===", "!=", "&", "^", "|", "&&", "||",  "=",
      "+=", "-=", "*=", "/=", "%=", "<<=", ">>=", "&=", "^=", "|="

  ]
  @@BRACKETS = [
      "(", "[", "{"
  ]
  @@RES_WORDS = [
      "not", "while", "rescue", "and", "or", "if", "when", "unless",
      "case", "until", "begin", "for", "new", "elsif"
  ]

  @@IGNORE_WORDS = [
      "def", "class", "module", "public", "private", "protected", "end"
  ]

  def initialize(text)
    begin
      @code_text = text.split(/\n/).select {|line| line != ''}
      calculate
    rescue
      puts "incorrect Ruby code"
    end
  end

  def calculate
    @operands = {}
    @operators = {}
    brackets = []
    @code_text.select {|line| !@@IGNORE_WORDS.find {|word| /^.*\b#{word}\b.*$/ === line}}.each do |line|
      (
        @operands[line[/".*"/]] = 0 if @operands[line[/".*"/]].nil?
        @operands[line[/".*"/]] += 1
        line.sub!(/".*"/, " ")
      ) while /^.*".*".*$/ === line
      @@RES_WORDS.each do |word|
        words_line = line
        (
          @operators[word] = 0 if @operators[word].nil?
          @operators[word] += 1
          line.sub!(/\b#{Regexp.escape word}\b/, " ")
        ) while /^.*\b#{Regexp.escape word}\b.*$/ === line
      end
      @@PURE_OPS.each do |op|
        ops_line = line
        (
          @operators[op] = 0 if @operators[op].nil?
          @operators[op] += 1
          line.sub!(/\s#{Regexp.escape op}\s/, " ")
        ) while /^.*\s#{Regexp.escape op}\s.*$/ === line
      end
      @@BRACKETS.each do |br|
        br_line = line
        (
          @operators[br] = 0 if @operators[br].nil?
          @operators[br] += 1
          line.sub!(/\s#{Regexp.escape br}/, " ")
        ) while /^.*\s#{Regexp.escape br}.*$/ === line
      end
      line.split(/\s+/).map {|literal| literal.gsub(/[\)\]\}]/, "")}.each do |literal|
        if /\w*\(/ === literal
          literal.sub!(/\(/, "")
          @operators[literal] = 0 if @operators[literal].nil?
          @operators[literal] += 1
        elsif /^\w+$/ === literal
          @operands[literal] = 0 if @operands[literal].nil?
          @operands[literal] += 1
        end
      end
    end
    @n1 = @operators.length
    @n2 = @operands.length
    @n = @n1 + @n2
    @N1 = @operators.to_a.inject(0) {|num, val| num + val[1]}
    @N2 = @operands.to_a.inject(0) {|num, val| num + val[1]}
    @N = @N1 + @N2
    @v = @N * Math.log2(@n)

  end
  private :calculate

  def show
    size  = @operands.length > @operators.length ? @operands.length : @operators.length;
    printf("%3s  %15s   %3s  | %3s   %15s  %3s\n", "j", "operators", "f1j", "i", "operand", "f2i")

    size.times do |i|
      #printf("j  operator  f1j  i   operand   f2i")
      printf("--------------------------------------------------------\n")
      printf("%3d  %15s   %3d  | ", i + 1, @operators.to_a[i][0], @operators.to_a[i][1]) if i < @operators.length
      printf("%3d   %15s  %3d", i + 1, @operands.to_a[i][0], @operands.to_a[i][1]) if i < @operands.length
      printf("\n")
    end
    printf("--------------------------------------------------------\n")
    printf("n1 =%3d  %9s   N1 =%3d| ", @n1, "", @N1)
    printf("n2 =%3d  %9s N2 =%3d\n\n", @n2, "", @N2)
    printf("n = %d\nN = %d\nv = %f\n\n\n\n", @n, @N, @v)
  end
end