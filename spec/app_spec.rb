# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe "App" do
  include Rack::Test::Methods
  def app
    @app ||= Sinatra::Application
  end

  describe "レスポンスの精査" do
    describe "/へのアクセス" do
      before { get '/' }
      subject { last_response }
      it "正常なレスポンスが返ること" do
        is_expected.to be_ok
      end
      it "Helloと出力されること" do
        expect(subject.body).to eq "Hello"
      end
    end
  end
end
