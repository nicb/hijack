require 'spec_helper'

describe 'Hijack::OutputDrivers::Radiant::Extensions::String' do

  before :example do
  end

  it 'strips suffixes' do
    strip_cases =
    {
      'normal.case' => 'normal',
      'some.what.funny.t' => 'some.what.funny',
      'real_world case.php' => 'real_world case',
      'this has no suffix' => 'this has no suffix',
    }
    strip_cases.each { |example, result| expect(example.strip_suffix).to eq(result), "#{example.strip_suffix} != #{result}" }
  end

  it 'can humanize_ignorecase a string' do
    humanize_ignorecase_cases =
    {
      'veduta-dal_terrazzo-casa_Scelsi' => 'Veduta dal terrazzo casa Scelsi',
      '  another_Test' => '  another Test',
      '__FILE__' => '  FILE  ',
    }
    humanize_ignorecase_cases.each { |ex, res| expect(ex.humanize_ignorecase).to eq(res), "'#{ex.humanize_ignorecase}' != '#{res}'" }
  end

  it 'radiantizes image names and links' do
    image_name_cases =
    {
      '../images/1442917869_IMG_6068.JPG' => 'IMG 6068',
      'http://www.scelsi.it/images/1443692576_teatroalla scala.jpg' => 'Teatroalla scala',
      'http://www.scelsi.it/images/1443099283_veduta dal terrazzo casa Scelsi.jpg' => 'Veduta dal terrazzo casa Scelsi',
      'img/newsletter.jpg' => 'Newsletter',
      'brutal_devaster.php' => 'Brutal devaster',
    }
    image_name_cases.each { |example, result| expect(example.radiantize).to eq(result), "'#{example.radiantize}' != '#{result}'" }
  end

end
