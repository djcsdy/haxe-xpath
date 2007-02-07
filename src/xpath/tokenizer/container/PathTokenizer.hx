/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.tokenizer.container;
import xpath.tokenizer.Tokenizer;
import xpath.tokenizer.TokenizeState;
import xpath.tokenizer.util.Sequence;
import xpath.tokenizer.util.Disjunction;
import xpath.tokenizer.util.Optional;
import xpath.tokenizer.util.Repetition;
import xpath.tokenizer.container.StepDelimiterTokenizer;
import xpath.tokenizer.container.StepTokenizer;
import xpath.tokenizer.container.UnaryStepTokenizer;
import xpath.tokenizer.token.BeginPathTokenizer;
import xpath.tokenizer.token.EndPathTokenizer;


class PathTokenizer implements Tokenizer {
	
	private static var instance:PathTokenizer;
	
	private var tokenizer:Tokenizer;
	
	
	public static function getInstance () :PathTokenizer {
		if (instance == null) {
			instance = new PathTokenizer();
			instance.init();
		}
		return instance;
	}
	
	private function new () {
	}
	
	private function init () :Void {
		tokenizer = new Sequence([
			cast(BeginPathTokenizer.getInstance(), Tokenizer), new Disjunction([
				cast(StepDelimiterTokenizer.getInstance(), Tokenizer),
				#if xpathExtensions
				new Sequence([
					cast(new Optional([
						cast(StepDelimiterTokenizer.getInstance(), Tokenizer)
					]), Tokenizer), StepTokenizer.getInstance(),
					new Repetition([
						cast(StepDelimiterTokenizer.getInstance(), Tokenizer),
						StepTokenizer.getInstance()
					])
				])
				#else true
				new Sequence([
					cast(new Disjunction([
						cast(new Sequence([
							cast(StepDelimiterTokenizer.getInstance(), Tokenizer),
							UnaryStepTokenizer.getInstance()
						]), Tokenizer), StepTokenizer.getInstance()
					]), Tokenizer),
					new Repetition([
						cast(StepDelimiterTokenizer.getInstance(), Tokenizer),
						UnaryStepTokenizer.getInstance()
					])
				])
				#end
			]), EndPathTokenizer.getInstance()
		]);
	}		
	
	public function tokenize (state:TokenizeState) :TokenizeState {
		return tokenizer.tokenize(state);
	}
	
}