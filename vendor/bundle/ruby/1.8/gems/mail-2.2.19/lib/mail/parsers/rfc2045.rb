# Autogenerated from a Treetop grammar. Edits may be lost.


module Mail
  module RFC2045
    include Treetop::Runtime

    def root
      @root ||= :tspecials
    end

    def _nt_tspecials
      start_index = index
      if node_cache[:tspecials].has_key?(index)
        cached = node_cache[:tspecials][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0 = index
      if has_terminal?("(", false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("(")
        r1 = nil
      end
      if r1
        r0 = r1
      else
        if has_terminal?(")", false, index)
          r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure(")")
          r2 = nil
        end
        if r2
          r0 = r2
        else
          if has_terminal?("<", false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 1))
            @index += 1
          else
            terminal_parse_failure("<")
            r3 = nil
          end
          if r3
            r0 = r3
          else
            if has_terminal?(">", false, index)
              r4 = instantiate_node(SyntaxNode,input, index...(index + 1))
              @index += 1
            else
              terminal_parse_failure(">")
              r4 = nil
            end
            if r4
              r0 = r4
            else
              if has_terminal?("@", false, index)
                r5 = instantiate_node(SyntaxNode,input, index...(index + 1))
                @index += 1
              else
                terminal_parse_failure("@")
                r5 = nil
              end
              if r5
                r0 = r5
              else
                if has_terminal?(",", false, index)
                  r6 = instantiate_node(SyntaxNode,input, index...(index + 1))
                  @index += 1
                else
                  terminal_parse_failure(",")
                  r6 = nil
                end
                if r6
                  r0 = r6
                else
                  if has_terminal?(";", false, index)
                    r7 = instantiate_node(SyntaxNode,input, index...(index + 1))
                    @index += 1
                  else
                    terminal_parse_failure(";")
                    r7 = nil
                  end
                  if r7
                    r0 = r7
                  else
                    if has_terminal?(":", false, index)
                      r8 = instantiate_node(SyntaxNode,input, index...(index + 1))
                      @index += 1
                    else
                      terminal_parse_failure(":")
                      r8 = nil
                    end
                    if r8
                      r0 = r8
                    else
                      if has_terminal?('\\', false, index)
                        r9 = instantiate_node(SyntaxNode,input, index...(index + 1))
                        @index += 1
                      else
                        terminal_parse_failure('\\')
                        r9 = nil
                      end
                      if r9
                        r0 = r9
                      else
                        if has_terminal?("<", false, index)
                          r10 = instantiate_node(SyntaxNode,input, index...(index + 1))
                          @index += 1
                        else
                          terminal_parse_failure("<")
                          r10 = nil
                        end
                        if r10
                          r0 = r10
                        else
                          if has_terminal?(">", false, index)
                            r11 = instantiate_node(SyntaxNode,input, index...(index + 1))
                            @index += 1
                          else
                            terminal_parse_failure(">")
                            r11 = nil
                          end
                          if r11
                            r0 = r11
                          else
                            if has_terminal?("/", false, index)
                              r12 = instantiate_node(SyntaxNode,input, index...(index + 1))
                              @index += 1
                            else
                              terminal_parse_failure("/")
                              r12 = nil
                            end
                            if r12
                              r0 = r12
                            else
                              if has_terminal?("[", false, index)
                                r13 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                @index += 1
                              else
                                terminal_parse_failure("[")
                                r13 = nil
                              end
                              if r13
                                r0 = r13
                              else
                                if has_terminal?("]", false, index)
                                  r14 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                  @index += 1
                                else
                                  terminal_parse_failure("]")
                                  r14 = nil
                                end
                                if r14
                                  r0 = r14
                                else
                                  if has_terminal?("?", false, index)
                                    r15 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                    @index += 1
                                  else
                                    terminal_parse_failure("?")
                                    r15 = nil
                                  end
                                  if r15
                                    r0 = r15
                                  else
                                    if has_terminal?("=", false, index)
                                      r16 = instantiate_node(SyntaxNode,input, index...(index + 1))
                                      @index += 1
                                    else
                                      terminal_parse_failure("=")
                                      r16 = nil
                                    end
                                    if r16
                                      r0 = r16
                                    else
                                      @index = i0
                                      r0 = nil
                                    end
                                  end
                                end
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      node_cache[:tspecials][start_index] = r0

      r0
    end

    def _nt_ietf_token
      start_index = index
      if node_cache[:ietf_token].has_key?(index)
        cached = node_cache[:ietf_token][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0 = index
      if has_terminal?("7bit", false, index)
        r1 = instantiate_node(SyntaxNode,input, index...(index + 4))
        @index += 4
      else
        terminal_parse_failure("7bit")
        r1 = nil
      end
      if r1
        r0 = r1
      else
        if has_terminal?("8bit", false, index)
          r2 = instantiate_node(SyntaxNode,input, index...(index + 4))
          @index += 4
        else
          terminal_parse_failure("8bit")
          r2 = nil
        end
        if r2
          r0 = r2
        else
          if has_terminal?("binary", false, index)
            r3 = instantiate_node(SyntaxNode,input, index...(index + 6))
            @index += 6
          else
            terminal_parse_failure("binary")
            r3 = nil
          end
          if r3
            r0 = r3
          else
            if has_terminal?("quoted-printable", false, index)
              r4 = instantiate_node(SyntaxNode,input, index...(index + 16))
              @index += 16
            else
              terminal_parse_failure("quoted-printable")
              r4 = nil
            end
            if r4
              r0 = r4
            else
              if has_terminal?("base64", false, index)
                r5 = instantiate_node(SyntaxNode,input, index...(index + 6))
                @index += 6
              else
                terminal_parse_failure("base64")
                r5 = nil
              end
              if r5
                r0 = r5
              else
                @index = i0
                r0 = nil
              end
            end
          end
        end
      end

      node_cache[:ietf_token][start_index] = r0

      r0
    end

    module CustomXToken0
    end

    def _nt_custom_x_token
      start_index = index
      if node_cache[:custom_x_token].has_key?(index)
        cached = node_cache[:custom_x_token][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0, s0 = index, []
      if has_terminal?('\G[xX]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      s0 << r1
      if r1
        if has_terminal?("-", false, index)
          r2 = instantiate_node(SyntaxNode,input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("-")
          r2 = nil
        end
        s0 << r2
        if r2
          s3, i3 = [], index
          loop do
            r4 = _nt_token
            if r4
              s3 << r4
            else
              break
            end
          end
          if s3.empty?
            @index = i3
            r3 = nil
          else
            r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
          end
          s0 << r3
        end
      end
      if s0.last
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
        r0.extend(CustomXToken0)
      else
        @index = i0
        r0 = nil
      end

      node_cache[:custom_x_token][start_index] = r0

      r0
    end

    def _nt_iana_token
      start_index = index
      if node_cache[:iana_token].has_key?(index)
        cached = node_cache[:iana_token][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      s0, i0 = [], index
      loop do
        r1 = _nt_token
        if r1
          s0 << r1
        else
          break
        end
      end
      if s0.empty?
        @index = i0
        r0 = nil
      else
        r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      end

      node_cache[:iana_token][start_index] = r0

      r0
    end

    def _nt_token
      start_index = index
      if node_cache[:token].has_key?(index)
        cached = node_cache[:token][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      i0 = index
      if has_terminal?('\G[\\x21-\\x27]', true, index)
        r1 = true
        @index += 1
      else
        r1 = nil
      end
      if r1
        r0 = r1
      else
        if has_terminal?('\G[\\x2a-\\x2b]', true, index)
          r2 = true
          @index += 1
        else
          r2 = nil
        end
        if r2
          r0 = r2
        else
          if has_terminal?('\G[\\x2c-\\x2e]', true, index)
            r3 = true
            @index += 1
          else
            r3 = nil
          end
          if r3
            r0 = r3
          else
            if has_terminal?('\G[\\x30-\\x39]', true, index)
              r4 = true
              @index += 1
            else
              r4 = nil
            end
            if r4
              r0 = r4
            else
              if has_terminal?('\G[\\x41-\\x5a]', true, index)
                r5 = true
                @index += 1
              else
                r5 = nil
              end
              if r5
                r0 = r5
              else
                if has_terminal?('\G[\\x5e-\\x7e]', true, index)
                  r6 = true
                  @index += 1
                else
                  r6 = nil
                end
                if r6
                  r0 = r6
                else
                  @index = i0
                  r0 = nil
                end
              end
            end
          end
        end
      end

      node_cache[:token][start_index] = r0

      r0
    end

  end

  class RFC2045Parser < Treetop::Runtime::CompiledParser
    include RFC2045
  end

end
