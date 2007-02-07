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


package xpath.tokenizer;
import xpath.tokenizer.TokenizeState;


/** The process of compiling an XPath query string is implemented in two parts&mdash;a "tokenizer",
 * implemented in xpath.tokenizer, and a parser, implemented in xpath.parser.
 *
 * The tokenizer is in fact a scannerless recursive descent parser; it is referred to as a
 * 'tokenizer' because although it is implemented as a parser it does not directly build a parse
 * tree. Instead, its output is an array of Tokens which unambiguously represent the query. Both
 * structural and semantic information is represented by tokens, such that a parse tree may be
 * efficiently constructed from the tokens in a sequential, context-free manner.
 *
 * Once tokenization is complete, the resulting array of Tokens is passed to the parser, which uses
 * the Tokens to build a parse tree.
 *
 * ==Grammar==
 * The tokenizer consists of a number of classes implementing the interface
 * xpath.tokenizer.Tokenizer, each of which corresponds to a single rule in the EBNF
 * grammar. To simplify the implementation, the grammar distinguishes between container rules
 * and token rules.
 *
 * ===Container rules===
 * Container rules reference other EBNF rules, but do not reference literal strings. Classes
 * implementing container rules are located in the package xpath.tokenizer.container.
 * Container tokenizers are all implemented using a number of helper classes in
 * xpath.tokenizer.util, each of which attempts to apply one or more other tokenizers
 * according to the rules of various features of EBNF notation.
 *
 * [//TODO Container grammar here]
 *
 * ===Token rules===
 * Token rules do not reference other EBNF rules, but do reference literal strings. Except for a few
 * special cases, each token rule corresponds directly to a token in the output of the tokenizer; for
 * example, a successful match of the rule BeginGroup results in the production of a BeginGroupToken.
 * Token tokenizers are implemented as hand-written scanners which examine the query string one
 * character at a time.
 *
 * [//TODO Token grammar here]
 *
 * ===Extended grammar===
 * If XPath is compiled with the [xpathExtensions] compile flag, the following rules override their
 * equivalents above:
 *
 * [//TODO Extended grammar here] */
interface Tokenizer {

	public function tokenize (state:TokenizeState) :TokenizeState;

}