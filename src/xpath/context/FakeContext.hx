/* Haxe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package xpath.context;
import xpath.xml.XPathXml;
import xpath.xml.XPathHxXml;


/** Fake class extending [Context] for unit testing. */
class FakeContext extends Context {
	
	/** Constructs a new [FakeContext] with the same arguments as
	 * the constructor for [Context], except that they are all
	 * optional. Defaults are:<ul>
	 *   <li>[node]: A [CDATA] node containing the text [abc].</li>
	 *   <li>[position]: 0.</li>
	 *   <li>[size]: 0.</li>
	 *   <li>[environment]: an instance of [DynamicEnvironment] with
	 *     no variables and no functions attached.</li>
	 * </ul>*/
	public function new (
		?node:XPathXml, ?position:Int,
		?size:Int, ?environment:Environment
	) {
		if (node == null) node = XPathHxXml.wrapNode(Xml.createCData("abc"));
		if (position == null) position = 0;
		if (size == null) size = 0;
		if (environment == null) environment = new DynamicEnvironment();
		super(node, position, size, environment);
	}

}
