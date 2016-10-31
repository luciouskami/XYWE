//http://stackoverflow.com/questions/1854703/how-to-set-richtextbox-font-for-the-next-text-to-be-written
//https://msdn.microsoft.com/en-us/library/cc294992.aspx

using System;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Threading;
using System.Collections.Generic;
using System.IO;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Controls;

namespace XYTextColorMaker
{
    public partial class MainWindow : Window
    {
        private void InsertRun(TextPointer pointer, string text, Color color)
        {
            var run = new Run(text, pointer);
            run.Foreground = new SolidColorBrush(color);
        }
        private void AppendRun(string text, Color color)
        {
            InsertRun(tbInput.Document.ContentEnd, text, color);
        }
        private void AppendLineBreak()
        {
            tbInput.Document.ContentEnd.InsertLineBreak();
        }



        public MainWindow()
        {
            InitializeComponent();
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            tbInput.Focus();
        }
        private void TbInput_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                e.Handled = true;
                tbInput.Selection.Text = "";
                var pos = tbInput.Selection.End.InsertLineBreak();
                var nextPos = pos.GetPositionAtOffset(1);
                if (nextPos.IsAtLineStartPosition) tbInput.Selection.Select(nextPos, nextPos);
            }
        }
        private void CcColor_SelectedColorChanged(object sender, RoutedPropertyChangedEventArgs<Color?> e)
        {
            if (!tbInput.Selection.IsEmpty)
            {
                tbInput.Selection.ApplyPropertyValue(
                    ForegroundProperty, new SolidColorBrush((Color)ccColor.SelectedColor));
            }
        }
        private void Button_Click_MakeTriggerText(object sender, RoutedEventArgs e)
        {
            RefreshOutputWts("\n");
        }
        private void Button_Click_MakeObjectEditorText(object sender, RoutedEventArgs e)
        {
            RefreshOutputWts("|n");
        }
        private void Button_Click_PatchSingleColor(object sender, RoutedEventArgs e)
        {
            var brush = (sender as Button).Foreground as SolidColorBrush;
            ccColor.SelectedColor = brush.Color;
            tbInput.Focus();
        }

        private void Button_Template_Item_1(object sender, RoutedEventArgs e)
        {
            // TODO
            tbInput.Document = new FlowDocument();

            AppendRun("物品名字(", Colors.White);
            AppendRun("物品品质", Colors.Red);
            AppendRun(")", Colors.White);
            AppendLineBreak();
            AppendLineBreak();
            AppendRun("物品历史", Colors.DarkGoldenrod);
            AppendLineBreak();
            AppendLineBreak();
            AppendRun("物品描述", Colors.White);
            AppendLineBreak();
            AppendLineBreak();
            AppendRun("物品吐槽", Colors.Gray);
        }



        private string _Wts = null;
        private string _Xaml = null;
        private string _LineBreaker = null;
        private string _LastXaml = null;
        private string _LastLineBreaker = null;

        private void RefreshOutputWts(string lineBreaker)
        {
            RefreshXamlContent();
            if (IsXamlRepeat()) return;
            ConvertXamlToWts();
            OutputWts();
        }
        private void RefreshXamlContent()
        {
            var range = new TextRange(tbInput.Document.ContentStart, tbInput.Document.ContentEnd);
            var stream = new MemoryStream();
            range.Save(stream, DataFormats.Xaml);
            _Xaml = Encoding.UTF8.GetString(stream.ToArray());
        }
        private bool IsXamlRepeat()
        {
            if ((_LastXaml != null && _Xaml == _LastXaml) && (_LastLineBreaker != null && _LineBreaker == _LastLineBreaker)) return true;
            _LastXaml = _Xaml;
            _LastLineBreaker = _LineBreaker;
            return false;
        }
        private void ConvertXamlToWts()
        {
            _Wts =
                Regex.Replace(
                Regex.Replace(
                Regex.Replace(
                Regex.Replace(
                    _Xaml
                    .Remove(0, _Xaml.IndexOf("<Paragraph>"))
                    .Replace("<Paragraph>", "")
                    .Replace("</Paragraph>", "")
                    .Replace("</Section>", "")
                    .Replace(" xml:lang=\"zh-cn\"", "")
                    .Replace("<LineBreak />", _LineBreaker)
                , "<Run>([^<]*)</Run>", "$1")
                , "<Run Foreground=\"#(\\w+)\">([^<]*)</Run>", "|C$1$2|R")
                , "\\|C\\w{8}\\|R", "")
                , "(?:\\|C(?<color>\\w{8})(?<content>[^\\|]+)\\|R)(?:\\|C\\k'color'(?<content>[^\\|]+)\\|R){1,}", match =>
                {
                    var capCtr = "";
                    foreach (var content in match.Groups["content"].Captures) capCtr += content;
                    return $"|C{match.Groups["color"]}{capCtr}|R";
                });
        }
        private void OutputWts()
        {
            tbOutput.Text = _Wts;
        }
    }
}
