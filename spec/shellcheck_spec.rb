require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerShellcheck do
    it 'should be a plugin' do
      expect(Danger::DangerShellcheck.new(nil)).to be_a Danger::Plugin
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.shellcheck
      end

      it 'Parses JSON with errors, warnings, info and style violations' do
        file_path = File.expand_path('../shellcheck.json', __FILE__)
        @my_plugin.report(file_path)
        expect(@dangerfile.status_report[:errors].length).to be == 3
        expect(@dangerfile.status_report[:warnings].length).to be == 10
        expect(@dangerfile.status_report[:markdowns]).to eq([])
      end

      it 'Displays a summary message' do
        file_path = File.expand_path('../shellcheck.json', __FILE__)
        @my_plugin.report(file_path)
        expect(@dangerfile.status_report[:messages]).to eq(['ShellCheck Summary: Analyzed 5 files. Found 3 errors. 2 Warnings, 7 Info and 1 Style Violations.'])
      end

      it 'Displays a properly formatted error message' do
        file_path = File.expand_path('../shellcheck.json', __FILE__)
        @my_plugin.report(file_path)
        expect(@dangerfile.status_report[:errors][0]).to eq('ios/run_pull_request_tests.sh: #L7 -> 2086 - Double quote to prevent globbing and word splitting.')
      end

      it 'Displays a properly formatted warning message' do
        file_path = File.expand_path('../shellcheck.json', __FILE__)
        @my_plugin.report(file_path)
        expect(@dangerfile.status_report[:warnings][0]).to eq('maintenance/clean_jenkins_logs.sh: #L8 -> 2061 - Quote the parameter to -name so the shell won\'t interpret it.')
      end
    end
  end
end
